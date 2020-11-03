#!/usr/bin/env python3

import argparse
import jinja2
import json


def build_parser():
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
        help="JSON object containing the url, branches and start_path of a source for the website.")
    parser.add_argument(
        "-u",
        "--ui-bundle-zip-url",
        metavar="URL",
        required=True,
        dest="ui_bundle_url",
        help="Local path or URL to UI bundle.zip.")

    return parser


# --- main ---

args = build_parser().parse_args()

site_dict = json.loads(args.site_info)
source_list = []
ui_bundle_dict = {}

for source in args.content_source_list:
    source_obj = json.loads(source)
    source_list.append(json.loads(source))

ui_bundle_dict["url"] = args.ui_bundle_url

template_loader = jinja2.FileSystemLoader(searchpath="./")
template_env = jinja2.Environment(loader=template_loader)
template = template_env.get_template(args.file_path)
template.stream(site=site_dict, source_list=source_list, ui_bundle=ui_bundle_dict).dump("site.yml")
