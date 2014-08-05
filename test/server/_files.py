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
import unittest

import mock
from mock import MagicMock

from _constants import SERVER_PATH
from _constants import APP_PATH
from _constants import INDEX_PATH
from _constants import CONTENT_PATH
from _constants import URL_APP_PREFIX
from _constants import JSON_CONTENT_TYPE
from _constants import RESOURCE_NOT_FOUND

sys.path.append(SERVER_PATH)
import server
from server import application
from server.files import FileHandler

from _files_urls import URLS_NO_EXTENSION, URLS_EXTENSION_APP, URLS_EXTENSION
from _files_urls import URLS_EXTENSION_RESOURCE, URLS_EXTENSION_REGULAR
from _files_urls import add_url_app_prefix

import yaml
import json


class MockHandler(FileHandler):
    def __init__(self):
        self.request = MagicMock()

class MockHandlerPath(MockHandler):
    def __init__(self):
        super(MockHandlerPath,self).__init__()
        self.get_app_index = MagicMock()
        self.get_app_file = MagicMock()
        self.get_resource = MagicMock()

class Path(unittest.TestCase):
    def setUp(self):
        self.handler = MockHandlerPath()

    def test_noextension(self):
        """
        Any URL with no extension
        will be served by get_app_index()
        """
        for url in URLS_NO_EXTENSION:
            self.handler.request.path = url
            self.handler.get()
            self.handler.get_app_index.assert_called_with()

    def test_extension_app_prefix(self):
        """
        Any URL with an extension AND the __app prefix
        will be served by get_app_file()
        """
        for (url, content_type) in URLS_EXTENSION_APP:
            url = add_url_app_prefix(url)
            self.handler.request.path = url
            self.handler.get()
            self.handler.get_app_file.assert_called_with()

    def test_extension(self):
        """
        Any URL with an extension (an NO __app prefix)
        will be served by get_resource()
        """
        for (url, target_ext, content_type) in URLS_EXTENSION:
            self.handler.request.path = url
            self.handler.get()
            self.handler.get_resource.assert_called_with()

class MockHandlerGet(MockHandler):
    def __init__(self):
        super(MockHandlerGet,self).__init__()
        self.serve_regular_file = MagicMock()
        self.serve_resource = MagicMock()

class Get(unittest.TestCase):
    def setUp(self):
        self.handler = MockHandlerGet()

    def test_get_app_index(self):
        """
        get_app_index() always serves Angular.js index.html
        """
        self.handler.get_app_index()
        self.handler.serve_regular_file.assert_called_with(INDEX_PATH)

    def test_get_app_file(self):
        """
        get_app_file() ignores the __app prefix and serves from 
        APP_PATH
        """
        for (url, content_type) in URLS_EXTENSION_APP:
            self.handler.request.path = add_url_app_prefix(url)

            self.handler.get_app_file()

            target_path = os.path.join(APP_PATH, url)
            self.handler.serve_regular_file.assert_called_with(target_path)

    def test_get_resource_regular(self):
        """
        Serve regular file from CONTENT_PATH;
        if extension != .cib
        """
        for (url, target_ext, content_type) in URLS_EXTENSION_REGULAR:
            self.handler.request.path = url
            self.handler.get_resource()

            target_path = os.path.join(CONTENT_PATH, url.strip('/'))
            self.handler.serve_regular_file.assert_called_with(target_path)

    def test_get_resource(self):
        """
        Serve resource from CONTENT_PATH
        if extension == .cib
        """
        for (url, target_ext, content_type) in URLS_EXTENSION_RESOURCE:
            self.handler.request.path = url
            self.handler.get_resource()

            name, ext = os.path.splitext(url.strip('/'))

            target_path = os.path.join(CONTENT_PATH, name)
            self.handler.serve_resource.assert_called_with(target_path)

class MockHandlerServe(MockHandler):
    def __init__(self):
        super(MockHandlerServe,self).__init__()
        self.write = MagicMock()
        self.set_header = MagicMock()

        self.mock_content_type = 'phony/phony; charset=UTF-8'
        self.guess_content_type = MagicMock(return_value=self.mock_content_type)

        self.serve_resource_yaml = MagicMock()
        self.serve_resource_markdown = MagicMock()
        self.serve_resource_not_found = MagicMock()

class Serve(unittest.TestCase):
    def setUp(self):
        self.handler = MockHandlerServe()

    def test_serve_regular_file(self):
        """
        Test all regular file (NOT app and NOT .cib)
        """
        for (url, content_type) in URLS_EXTENSION_APP:
            target_path = os.path.join(APP_PATH, url.strip('/'))
            self.assert_serve_regular_file(target_path)

        for (url, target_ext, content_type) in URLS_EXTENSION_REGULAR:
            target_path = os.path.join(CONTENT_PATH, url.strip('/'))
            self.assert_serve_regular_file(target_path)

    def assert_serve_regular_file(self,target_path):
        """
        Guess content-type and serve
        """
        self.handler.serve_regular_file(target_path)
        self.handler.guess_content_type.assert_called_with(target_path)

        with open(target_path) as target_file:
            self.handler.write.assert_called_with(target_file.read())
            self.handler.set_header.assert_called_with('Content-Type', self.handler.mock_content_type)

    def test_serve_resource(self):
        """
        See ~/content/test for test files
        Serving order:
            * .yaml
            * .md
            * NOT FOUND
        """
        for (url, target_ext, content_type) in URLS_EXTENSION_RESOURCE:
            name, ext = os.path.splitext(url.strip('/'))
            target_path = os.path.join(CONTENT_PATH, name)

            self.handler.serve_resource(target_path)

            if target_ext == 'yaml':
                target_path = "%s.yaml" % target_path
                self.handler.serve_resource_yaml.assert_called_with(target_path)
            elif target_ext == 'md':
                target_path = "%s.md" % target_path
                self.handler.serve_resource_markdown.assert_called_with(target_path)
            else:
                self.handler.serve_resource_not_found.assert_called_with()

class MockHandlerServeResource(MockHandler):
    def __init__(self):
        super(MockHandlerServeResource,self).__init__()
        self.write = MagicMock()
        self.set_header = MagicMock()

        self.mock_content_type = 'mock/mock; charset=UTF-8'
        self.guess_content_type = MagicMock(return_value=self.mock_content_type)

        self.mock_md_data = [{'partial':'p01', 'params':{'text':'MD TEXT', 'service':'markdown', 'elm':'main'}}]
        self.data_from_md_text = MagicMock(return_value=self.mock_md_data)

class ServeResource(unittest.TestCase):
    def setUp(self):
        self.handler = MockHandlerServeResource()

        self.mock_data = [{'partial':'p01','params':{}}]
        self.mock_json_data = '[{"partial":"p01","params":{}}]'
        yaml.load = MagicMock(return_value = self.mock_data)
        json.dumps = MagicMock(return_value = self.mock_json_data)

    def test_serve_resource_target(self):
        """
        Serve, in order
            * .yaml file if it exists
            * .md file otherwise
            * NOT FOUND message
        """
        for (url, target_ext, content_type) in URLS_EXTENSION_RESOURCE:
            name, ext = os.path.splitext(url.strip('/'))
            target_path = os.path.join(CONTENT_PATH, name)
            target_path = "%s.%s" % (target_path, target_ext)

            if target_ext == 'yaml':
                self.assert_serve_resource_yaml(target_path)
            elif target_ext == 'md':
                self.assert_serve_resource_markdown(target_path)
            else:
                self.assert_serve_resource_not_found()

    def assert_serve_resource_yaml(self, target_path):
        """
        Serve .yaml file as .json

            * TODO: error handling (what if .yaml file does not parse?)
        """
        self.handler.serve_resource_yaml(target_path)

        with open(target_path) as target_file:
            yaml.load.assert_called_with(target_file.read())

        json.dumps.assert_called_with(self.mock_data)
        self.handler.set_header.assert_called_with('Content-Type', JSON_CONTENT_TYPE)
        self.handler.write.assert_called_with(self.mock_json_data)

    def assert_serve_resource_markdown(self, target_path):
        self.handler.serve_resource_markdown(target_path)

        with open(target_path) as target_file:
            self.handler.data_from_md_text.assert_called_with(target_file.read())

        json.dumps.assert_called_with(self.handler.mock_md_data)

        self.handler.set_header.assert_called_with('Content-Type', JSON_CONTENT_TYPE)
        self.handler.write.assert_called_with(self.mock_json_data)

    def assert_serve_resource_not_found(self):
        self.handler.serve_resource_not_found()
        self.handler.set_header.assert_called_with('Content-Type', JSON_CONTENT_TYPE)
        self.handler.write.assert_called_with(RESOURCE_NOT_FOUND)

class MockHandlerHelpers(MockHandler):
    def __init__(self):
        super(MockHandlerHelpers,self).__init__()

class Helpers(unittest.TestCase):
    def setUp(self):
        self.handler = MockHandlerHelpers()

    def test_data_from_md_text(self):
        mock_md_text = 'MOCK'
        data = self.handler.data_from_md_text(mock_md_text)
        self.assertEqual(mock_md_text, data[0]['data']['text'])

    def test_guess_content_type(self):
        for (url, target_ext, content_type) in URLS_EXTENSION_REGULAR:
            target_path = os.path.join(CONTENT_PATH, url)
            guessed_content_type = self.handler.guess_content_type(target_path)
            self.assertEqual(guessed_content_type, content_type)

        for (url, content_type) in URLS_EXTENSION_APP:
            target_path = os.path.join(APP_PATH, url)
            guessed_content_type = self.handler.guess_content_type(target_path)
            self.assertEqual(guessed_content_type, content_type)

if __name__ == '__main__':
    unittest.main()
