// Package spec implements parser for Cassandra protocol specification.
package spec

import (
	"fmt"
	"github.com/mvdan/xurls"
	"regexp"
	"strings"
)

type Document struct {
	License  []Text
	Title    string
	TOC      []TOCEntry
	Sections []Section
}

type TOCEntry struct {
	Number string
	Title  string
}

type Section struct {
	Number string
	Title  string
	Body   []Text
}

func (s Section) Empty() bool {
	return s.Number == "" && s.Title == "" && len(s.Body) == 0
}

// Text token in section body.
type Text struct {
	// Text that is displayed.
	Text string
	// SectionRef is the number of section this text links to.
	SectionRef string
	// Href is URL this text links to.
	Href string
}

var commentRegexp = regexp.MustCompile("^# ?(.*)$")
var emptyRegexp = regexp.MustCompile(`^\s*$`)
var titleRegexp = regexp.MustCompile(`^\s+(.*)\s*$`)
var headingRegexp = regexp.MustCompile(`^(\s*)(\d+(?:\.\d+)*)\.? (.*)$`)

const (
	mhSpaces = 1
	mhNumber = 2
	mhTitle  = 3
)

func Parse(data string) (Document, error) {
	lines := strings.Split(data, "\n")
	var license strings.Builder
	var doc Document
	l := 0
	// license
	for l < len(lines) {
		m := commentRegexp.FindStringSubmatch(lines[l])
		if len(m) != 2 {
			break
		}
		license.WriteString(m[1])
		license.WriteString("\n")
		l++
	}
	doc.License = parseBody(strings.Trim(license.String(), "\n "))
	// empty lines
	for l < len(lines) && emptyRegexp.MatchString(lines[l]) {
		l++
	}
	// title
	if l >= len(lines) {
		return Document{}, fmt.Errorf("missing title")
	}
	m := titleRegexp.FindStringSubmatch(lines[l])
	if len(m) != 2 {
		return Document{}, fmt.Errorf("line %d: title expected on line", l)
	}
	doc.Title = m[1]
	l++
	// empty lines
	for l < len(lines) && emptyRegexp.MatchString(lines[l]) {
		l++
	}
	// table of contents header
	if lines[l] != "Table of Contents" {
		return Document{}, fmt.Errorf("line %d: expected table of contents", l)
	}
	l++
	// empty lines
	for l < len(lines) && emptyRegexp.MatchString(lines[l]) {
		l++
	}
	// toc entries
	for l < len(lines) {
		if emptyRegexp.MatchString(lines[l]) {
			// end of toc
			break
		}
		mh := headingRegexp.FindStringSubmatch(lines[l])
		if len(mh) != 4 {
			return Document{}, fmt.Errorf("line %d: expected toc entry", l)
		}
		doc.TOC = append(doc.TOC, TOCEntry{
			Number: mh[mhNumber],
			Title:  mh[mhTitle],
		})
		l++
	}
	// empty lines
	for l < len(lines) && emptyRegexp.MatchString(lines[l]) {
		l++
	}
	// content
	tocIdx := 0
	var section Section
	var body []string

	for l < len(lines) {
		var sectionStart bool
		var newSection Section
		sectionStart, tocIdx, newSection = checkSectionStart(doc.TOC, tocIdx, lines[l])
		if sectionStart {
			section.Body = parseBody(strings.Join(body, "\n"))
			doc.Sections = append(doc.Sections, section)
			section = newSection
			body = nil
			l++
			// Eat empty lines
			for l < len(lines) && emptyRegexp.MatchString(lines[l]) {
				l++
			}
			continue
		}
		body = append(body, lines[l])
		l++
	}

	if len(body) > 0 || !section.Empty() {
		section.Body = parseBody(strings.Join(body, "\n"))
		doc.Sections = append(doc.Sections, section)
	}

	return doc, nil
}

// checkSectionStart checks if the line starts a new section and returns a new tocIdx.
func checkSectionStart(toc []TOCEntry, tocIdx int, line string) (bool, int, Section) {
	mh := headingRegexp.FindStringSubmatch(line)
	if len(mh) != 4 || tocIdx >= len(toc) {
		return false, tocIdx, Section{}
	}

	if mh[mhSpaces] == "" {
		if mh[mhNumber] == toc[tocIdx].Number {
			tocIdx++
		}
		return true, tocIdx, Section{
			Number: mh[mhNumber],
			Title:  mh[mhTitle],
		}
	}

	t := strings.ToLower(mh[3])
	for i := tocIdx; i < len(toc); i++ {
		t2 := strings.ToLower(toc[i].Title)
		if mh[mhNumber] == toc[i].Number && (strings.Contains(t, t2) || strings.Contains(t2, t)) {
			return true, i + 1, Section{
				Number: mh[mhNumber],
				Title:  mh[mhTitle],
			}
		}
	}

	return false, tocIdx, Section{}
}

var linkifyRegexp *regexp.Regexp
var sectionSubexpIdx int
var sectionsSubexpIdx int

func init() {
	s := xurls.Strict.String()
	r := `(?:<URL>)|[Ss]ection (\d+(?:\.\d+)*)|[Ss]ections (\d+(?:\.\d+)*(?:(?:, (?:and )?| and )\d+(?:\.\d+)*)*)`
	linkifyRegexp = regexp.MustCompile(strings.ReplaceAll(r, "<URL>", s))
	sectionSubexpIdx = xurls.Strict.NumSubexp()*2 + 2
	sectionsSubexpIdx = (xurls.Strict.NumSubexp()+1)*2 + 2
}

var sectionsSplitRegexp = regexp.MustCompile("(?:, (?:and )?| and )")

func parseBody(s string) []Text {
	var body []Text
	lastIdx := 0
	for _, m := range linkifyRegexp.FindAllStringSubmatchIndex(s, -1) {
		body = append(body, Text{Text: s[lastIdx:m[0]]})

		switch {
		case m[sectionSubexpIdx] != -1:
			sectionNo := s[m[sectionSubexpIdx]:m[sectionSubexpIdx+1]]
			body = append(body, Text{Text: s[m[0]:m[1]], SectionRef: sectionNo})
		case m[sectionsSubexpIdx] != -1:
			body = append(body, Text{Text: s[m[0]:m[sectionsSubexpIdx]]})
			sections := s[m[sectionsSubexpIdx]:m[sectionsSubexpIdx+1]]
			lastIdx2 := 0
			for _, m2 := range sectionsSplitRegexp.FindAllStringIndex(sections, -1) {
				sectionNo := sections[lastIdx2:m2[0]]
				body = append(body, Text{Text: sectionNo, SectionRef: sectionNo})
				// separator
				body = append(body, Text{Text: sections[m2[0]:m2[1]]})
				lastIdx2 = m2[1]
			}
			sectionNo := sections[lastIdx2:]
			body = append(body, Text{Text: sectionNo, SectionRef: sectionNo})
		default:
			href := s[m[0]:m[1]]
			body = append(body, Text{Text: href, Href: href})
		}
		lastIdx = m[1]
	}
	body = append(body, Text{Text: s[lastIdx:]})
	return body
}
