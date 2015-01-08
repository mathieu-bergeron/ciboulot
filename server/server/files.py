#! /usr/bin/python
# vim: set fileencoding=utf-8 :
#
# Ciboulot: a simple Web App for text-based content and Angular.js delivery
# Copyright (C) 2014 Mathieu Bergeron

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os
import sys

import tornado
import tornado.web

import yaml
import json

import mimetypes

import copy

CURRENT_PATH = os.path.dirname(os.path.realpath(__file__))
ROOT_PATH = os.path.join(CURRENT_PATH,'..','..')
CONFIG_PATH = os.path.join(ROOT_PATH, 'config')
SERVER_CONFIG_PATH = os.path.join(CONFIG_PATH, 'server')

sys.path.append(SERVER_CONFIG_PATH)

import constants
from constants import INDEX_PATH
from constants import APP_PATH
from constants import CONTENT_PATH
from constants import URL_APP_PREFIX
from constants import RESOURCE_EXTENSION
from constants import JSON_CONTENT_TYPE
from constants import RESOURCE_NOT_FOUND
from constants import MD_DATA
from constants import ACCEPT_POST

import re

URL_APP_PREFIX_PATTERN_RAW = "^([/]?%s[/]?)(.*)$" % URL_APP_PREFIX
URL_APP_PREFIX_PATTERN = re.compile(URL_APP_PREFIX_PATTERN_RAW)

class FileHandler(tornado.web.RequestHandler):

    def get_app_index(self):
        """
        Serves the Angular.js index.html file
        """
        self.serve_regular_file(INDEX_PATH)

    def get_app_file(self):
        """
        Ignores the __app prefix and serve from APP_PATH
        """
        match = URL_APP_PREFIX_PATTERN.match(self.request.path)
        file_path = match.group(2)
        target_path = os.path.join(APP_PATH, file_path)

        self.serve_regular_file(target_path)


    def get_resource(self):
        """
        Serve resource (*.cib) or file (*.*)
        from CONTENT_PATH
        """
        path = self.request.path.strip('/')
        name, ext = os.path.splitext(path)

        if ext == ".%s" % RESOURCE_EXTENSION:
            target_path = os.path.join(CONTENT_PATH, name)
            self.serve_resource(target_path)
        else:
            target_path = os.path.join(CONTENT_PATH, path)
            self.serve_regular_file(target_path)


    def guess_content_type(self, target_path):
        mimetype, encoding = mimetypes.guess_type(target_path)

        if mimetype is None:
            mimetype = "text/plain"

        if encoding is not None:
            return "%s; charset=%s" % (mimetype, encoding)
        else:
            return mimetype

    def serve_regular_file(self, target_path):
        """
        Get content_type and serve regular file
        """
        content_type = self.guess_content_type(target_path)

        self.set_header('Content-Type', content_type)

        with open(target_path) as target_file:
            self.write(target_file.read())

    def serve_resource(self, target_path):
        """
        Look for resource in that order
            * .yaml file
            * .md file
            * NOT FOUND
        """
        yaml_path = "%s.yaml" % target_path
        if os.path.isfile(yaml_path):
            self.serve_resource_yaml(yaml_path)

        else:
            md_path = "%s.md" % target_path

            if os.path.isfile(md_path):
                self.serve_resource_markdown(md_path)
            else:
                self.serve_resource_not_found()

    def serve_resource_yaml(self, target_path):
        """
        Serve a .yaml file as .json

        * TODO: error handling
                how/what to communicate on .yaml parsing error
        """
        self.set_header('Content-Type', JSON_CONTENT_TYPE)
        with open(target_path) as target_file:
            content = yaml.load(target_file.read())

            # Always serve a list
            if type(content) != list:
                content = [content]

            self.write(json.dumps(content))

    def data_from_md_text(self, md_text):
        data = copy.deepcopy(MD_DATA)
        data[0]['data']['text'] = md_text
        return data

    def serve_resource_markdown(self, target_path):
        """
        Serve a .md file as .json data
        """
        self.set_header('Content-Type', JSON_CONTENT_TYPE)

        with open(target_path) as target_file:
            md_text = target_file.read()

        md_data = self.data_from_md_text(md_text)
        json_data = json.dumps(md_data)
        self.write(json_data)

    def serve_resource_not_found(self):
        self.set_header('Content-Type', JSON_CONTENT_TYPE)
        self.write(RESOURCE_NOT_FOUND)


    def get(self):
        """
        Serve according to URL scheme (see ~/README.md)
        """
        path = self.request.path.strip('/')
        name, extension = os.path.splitext(path)

        if extension == '':
            self.get_app_index()
        else:
            if path.startswith(URL_APP_PREFIX):
                self.get_app_file()
            else:
                self.get_resource()

    def post(self):
        """
        Receive data
        """
        if not ACCEPT_POST:
            return

        # TODO: save data according to resource type
        path = self.request.path.strip('/')
        (name, ext) = os.path.splitext(path)
        name += '.md'
        markdown_path = os.path.join(CONTENT_PATH, name)

        data = json.loads(self.request.body)
        text = data['data']['text']

        with open(markdown_path,'w') as markdown_file:
            markdown_file.write(text)












