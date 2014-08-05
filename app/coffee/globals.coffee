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

'use strict'

# Export a few 'global'
# values via window.ciboulot
window.ciboulot = {}

class AngularBase
    __name: 'AngularBase'
    __injections: \
        ['$log']

    __inject: (cls, injected_values) ->
        ###
        inject value directly into the prototype
        ###
        for value, i in injected_values
            injection = cls.prototype.__injections[i]
            cls.prototype[injection] = value

    __factory: (cls) ->
        cls

    __module_install_function: (cls, module) ->
        () ->
            console.log 'NOT IMPLEMENTED'

    __install: (cls, module) ->
        factory = () ->
            cls.prototype.__inject cls, arguments
            cls.prototype.__factory cls

        name = cls.prototype.__name
        injections_and_factory = cls.prototype.__injections.concat factory

        module_install_function = cls.prototype.__module_install_function cls, module

        module_install_function name, injections_and_factory

# Class methos (prefixed __) need to be called with the cls as first
# argument
install_angular_cls = (module, cls) ->
    cls.prototype.__install cls, module

window.ciboulot[AngularBase.prototype.__name] = AngularBase
window.ciboulot['install_angular_cls'] = install_angular_cls
