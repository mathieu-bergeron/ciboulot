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

import tornado
import tornado.testing

from _constants import SERVER_PATH
from _constants import INDEX_PATH
from _constants import APP_PATH
from _constants import CONTENT_PATH
from _constants import URL_APP_PREFIX
from _constants import JSON_CONTENT_TYPE

sys.path.append(SERVER_PATH)
import server
from server import application

from _files_urls import URLS_NO_EXTENSION, URLS_EXTENSION_APP, URLS_EXTENSION
from _files_urls import URLS_EXTENSION_REGULAR, URLS_EXTENSION_RESOURCE
from _files_urls import add_url_app_prefix

class MyHTTPTest(tornado.testing.AsyncHTTPTestCase):
    def get_app(self):
        return application.application

    def test_noextension(self):
        """
        On any URL w/o extention, serve index.html of the Angular.js App
        """
        with open(INDEX_PATH) as index_file:
            index_html = index_file.read()

        for url in URLS_NO_EXTENSION:
            response = self.fetch(url)

            self.assertEqual(response.headers['Content-Type'], 'text/html')
            self.assertEqual(response.body, index_html)

    def test_extension_app_prefix(self):
        """
        If URL has an extension and an /__app/ prefix, server from APP_PATH
        """
        for (url, content_type) in URLS_EXTENSION_APP:

            target_path = os.path.join(APP_PATH, url)
            with open(target_path) as target_file:
                target_content = target_file.read()

            url = add_url_app_prefix(url)
            response = self.fetch(url)

            self.assertEqual(response.headers['Content-Type'], content_type)
            self.assertEqual(response.body, target_content)

    def test_extension_regular_file(self):
        """
        Extension *.* (but not *.cib), expect file
        """
        for (url, target_ext, content_type) in URLS_EXTENSION_REGULAR:
            target_path = os.path.join(CONTENT_PATH, url.strip('/'))

            with open(target_path) as target_file:
                target_content = target_file.read()

            response = self.fetch(url)

            self.assertEqual(response.headers['Content-Type'], content_type)
            self.assertEqual(response.body, target_content)

    def test_extension_resource(self):
        """
        Extension *.cib, expect .json data
        """
        for (url, target_ext, content_type) in URLS_EXTENSION_RESOURCE:
            name, ext = os.path.splitext(url.strip('/'))

            results_path = os.path.join(CONTENT_PATH, name)
            results_path = "%s.json" % results_path

            with open(results_path) as results_file:
                results_content = results_file.read()
                results_content = results_content.rstrip()

            response = self.fetch(url)

            self.assertEqual(response.headers['Content-Type'], JSON_CONTENT_TYPE)
            self.assertEqual(response.body, results_content)

if __name__ == '__main__':
    unittest.main()
