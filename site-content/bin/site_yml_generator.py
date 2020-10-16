#!/usr/bin/env python3

import argparse
import jinja2
import json

SITE_URL_DEFAULT = "https://cassandra.apache.org/"
BUNDLE_ZIP_URL_DEFAULT = "https://github.com/ianjevans/antora-ui-datastax/releases/download/v0.1oss/ui-bundle.zip"


def build_parser():
    parser = argparse.ArgumentParser(description="Generate the site.yml using the site.yml.template.")

    parser.add_argument(
        "file_path", metavar="FILE_PATH",  help="Path to site.template to use to generate site.yaml")
    parser.add_argument(
        "-s",
        "--site-url",
        metavar="URL",
        default=SITE_URL_DEFAULT,
        dest="site_url",
        help="URL to the website.")
    parser.add_argument(
        "-c"
        "--content-source",
        metavar="JSON",
        required=True,
        action="append",
        dest="content_source_list",
        help="JSON object containing the url, branches and start_path of a source for the website.")
    parser.add_argument(
        "-u",
        "--ui-bundle-zip-url",
        metavar="URL",
        default=BUNDLE_ZIP_URL_DEFAULT,
        dest="ui_bundle_url",
        help="Local path or URL to UI bundle.zip.")

    return parser


# --- main ---

args = build_parser().parse_args()

site_dict = {}
source_list = []
ui_bundle_dict = {}

site_dict["url"] = args.site_url

for source in args.content_source_list:
    source_obj = json.loads(source)
    source_list.append(json.loads(source))

ui_bundle_dict["url"] = args.ui_bundle_url

template_loader = jinja2.FileSystemLoader(searchpath="./")
template_env = jinja2.Environment(loader=template_loader)
template = template_env.get_template(args.file_path)
template.stream(site=site_dict, source_list=source_list, ui_bundle=ui_bundle_dict).dump("site.yml")
