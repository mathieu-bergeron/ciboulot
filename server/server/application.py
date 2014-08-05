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

import tornado
import tornado.web
import tornado.ioloop

from sockets import SocketHandler
from files import FileHandler

"""
Module creates a tornado application
with appropriate handlers
"""
application = tornado.web.Application(
                [
                 (r"/websocket.*", SocketHandler),
                 (r"/.*", FileHandler),
                ]
                )

def serve_forever(port):
    """
    Runs tornado application on specified port
    """
    application.listen(port)
    tornado.ioloop.IOLoop.instance().start()
