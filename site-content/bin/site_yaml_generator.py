#!/usr/bin/env python3

import abc
import argparse
import html.parser
import jinja2
import json
import requests
import re


class SiteYAML:
    def __init__(self):
        self._site_dict = {}
        self._source_list = []
        self._ui_bundle_dict = {}
        self._asciidoc_attributes = {}

    def set_site_setting(self, site_info):
        self._site_dict = json.loads(site_info)

    def set_content_source_setting(self, content_source_list):
        for source in content_source_list:
            self._source_list.append(json.loads(source))

    def set_ui_bundle_setting(self, ui_bundle_url):
        self._ui_bundle_dict["url"] = ui_bundle_url

    def set_asciidoc_attributes(self, release_download_url):
        response = requests.get(release_download_url)

        if not response.ok:
            raise IOError("Failed to retrieve download information from: {}".format(release_download_url))

        parser = DownloadsHTMLParser()
        parser.feed(response.text)

        for version in parser.version_list:
            version_key = version.key

            # Add the latest version as "latest" as well as its version number.
            if parser.latest == version.release_number:
                self._asciidoc_attributes["latest"] = {"name": version.name, "date": version.date}

            self._asciidoc_attributes[version_key] = {"name": version.name, "date": version.date}
        self._asciidoc_attributes['url_downloads_cassandra'] = release_download_url

    def generate_file(self):
        template_loader = jinja2.FileSystemLoader(searchpath="./")
        template_env = jinja2.Environment(loader=template_loader)
        template = template_env.get_template(args.file_path)
        template.stream(
            site=self._site_dict,
            source_list=self._source_list,
            ui_bundle=self._ui_bundle_dict,
            asciidoc_attributes=self._asciidoc_attributes
        ).dump("site.yaml")


class Version:
    def __init__(self, version):
        v_components = version.split(".")
        v_major = v_components[0]
        v_minor = v_components[1].split("-")[0]

        self.key = "v{}{}".format(v_major, v_minor)
        self.name = version
        self.date = ""
        self.release_number = float("{}.{}".format(v_major, v_minor))


class DownloadsHTMLParser(html.parser.HTMLParser, abc.ABC):
    def __init__(self):
        super().__init__()

        self._current_version = None
        self._previous_tag = None

        self._version_pattern = re.compile(r"^\d+\.\d+[.\-\w]+\d+")
        self._date_pattern = re.compile(r"^\d+-\d+-\d+")

        self.version_list = []
        self.latest = 0.0

    def handle_starttag(self, tag, attrs):
        if tag == "a" and len(attrs) > 0:
            for attr in attrs:
                if attr[0] == "href":
                    regex_match = self._version_pattern.match(attr[1])

                    if regex_match:
                        self._current_version = Version(regex_match.group())

                        if self._current_version.release_number > self.latest:
                            self.latest = self._current_version.release_number

    def handle_endtag(self, tag):
        self._previous_tag = tag

    def handle_data(self, data):
        if self._previous_tag == "a" and self._current_version:
            regex_match = self._date_pattern.match(data.strip())

            if regex_match:
                self._current_version.date = regex_match.group()
                self.version_list.append(self._current_version)
                self._current_version = None

        self._previous_tag = None


def build_arg_parser():
    parser = argparse.ArgumentParser(description="Generate the site.yml using the site.yml.template.")

    parser.add_argument(
        "file_path", metavar="FILE_PATH",  help="Path to site.template to use to generate site.yaml")
    parser.add_argument(
        "-s",
        "--site-info",
        metavar="JSON",
        required=True,
        dest="site_info",
        help="Information about the site.")
    parser.add_argument(
        "-c"
        "--content-source",
        metavar="JSON",
        required=True,
        action="append",
        dest="content_source_list",
        help="JSON object containing the url, branches, tags, and start_path of a source for the website.")
    parser.add_argument(
        "-u",
        "--ui-bundle-zip-url",
        metavar="URL",
        required=True,
        dest="ui_bundle_url",
        help="Local path or URL to UI bundle.zip.")
    parser.add_argument(
        "-r",
        "--release-download-url",
        metavar="URL",
        required=True,
        dest="release_download_url",
        help="URL to the page listing all the available downloads.")

    return parser

# --- main ---


args = build_arg_parser().parse_args()
site_yaml = SiteYAML()
site_yaml.set_site_setting(args.site_info)
site_yaml.set_content_source_setting(args.content_source_list)
site_yaml.set_ui_bundle_setting(args.ui_bundle_url)
site_yaml.set_asciidoc_attributes(args.release_download_url)
site_yaml.generate_file()
