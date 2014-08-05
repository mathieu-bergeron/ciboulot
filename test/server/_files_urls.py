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

import _constants
from _constants import URL_APP_PREFIX
from _constants import RESOURCE_EXTENSION

URLS_NO_EXTENSION = ['/','/pouet','/test/test/test','/__app/test/']
URLS_EXTENSION_APP = [
            ('css/ciboulot.css', 'text/css'),
        ]

def add_url_app_prefix(url):
    return "/%s/%s" % (URL_APP_PREFIX, url)

URLS_EXTENSION_RESOURCE = [
            ('/test/test','yaml', ''),
            ('/test/folder/test','md', ''),
            ('/test/notfound','notfound', ''),
        ]

URLS_EXTENSION_RESOURCE = [("%s.%s" % (url,RESOURCE_EXTENSION), target_ext, content_type) for (url, target_ext, content_type) in URLS_EXTENSION_RESOURCE]

URLS_EXTENSION_REGULAR = [
            ('/test/test.jpg','jpg', 'image/jpeg'),
            ('/test/folder/pattern.jpg','jpg', 'image/jpeg'),
        ]

URLS_EXTENSION = URLS_EXTENSION_RESOURCE + URLS_EXTENSION_REGULAR
