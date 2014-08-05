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

import sys
import unittest

import mock
from mock import MagicMock

from _constants import *
sys.path.append(SERVER_PATH)

import server
from server import application

from server.sockets import SocketHandler
from server.files import FileHandler

import tornado
import tornado.web
import tornado.ioloop

class TornadoApplication(unittest.TestCase):
    def test_tornado_application(self):
        """
        application.application is a tornado application with the appropriate handlers
        """
        tornado.web.Application = MagicMock()
        application = reload(server.application)

        tornado.web.Application.assert_called_with(
                [
                 (r"/websocket.*", SocketHandler),
                 (r"/.*", FileHandler),
                ]
                )

class ServerForever(unittest.TestCase):
    def setUp(self):
        application.application = MagicMock()
        application.application.listen = MagicMock()

        tornado.ioloop = MagicMock()
        tornado.ioloop.IOLoop = MagicMock()

        self.ioloop_instance = MagicMock()
        tornado.ioloop.IOLoop.instance = MagicMock(return_value=self.ioloop_instance)

        self.ioloop_instance.start = MagicMock()

    def test_server_forever(self):
        """
        serve_forever runs the tornado application on specified port
        """
        PORT = 8888
        application.serve_forever(PORT)

        application.application.listen.assert_called_with(PORT)
        tornado.ioloop.IOLoop.instance.assert_called_with()
        self.ioloop_instance.start.assert_called_with()


if __name__ == '__main__':
    unittest.main()
