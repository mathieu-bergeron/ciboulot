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

CURRENT_PATH = os.path.dirname(os.path.realpath(__file__))
ROOT_PATH = os.path.join(CURRENT_PATH,'..', '..')

SERVER_PATH = os.path.join(ROOT_PATH,'server')
CONTENT_PATH = os.path.join(ROOT_PATH,'content')

APP_PATH = os.path.join(ROOT_PATH, 'app')
INDEX_PATH = os.path.join(APP_PATH, 'index.html')

CONFIG_FILENAME = 'config.yaml'
CONFIG_FILE_PATH = os.path.join(CURRENT_PATH, CONFIG_FILENAME)

URL_APP_PREFIX = '__app'

RESOURCE_EXTENSION = 'cib'

JSON_CONTENT_TYPE = 'application/json; charset=UTF-8'

RESOURCE_NOT_FOUND = '[{"controller": "error", "data": {"text": "NOT FOUND"}}]'

MD_DATA = [{'controller':'markdown', 'data':{'text':'REPLACE BY MD CONTENT'}}]

ACCEPT_POST = True

