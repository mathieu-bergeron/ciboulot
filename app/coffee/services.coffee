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

# Include 'angular' (lib/angular/angular.js must be loaded)
angular

# Include 'Markdown' (lib/showdown/Markdown.Converter.js must be loaded)
Markdown

# Ciboulot globals
AngularBase = window.ciboulot['AngularBase']
install_angular_cls = window.ciboulot['install_angular_cls']
window.ciboulot['popup'] = 0

# NOTE
# Services should NOT deal with html elements, or $scope, or $compile into angular templates
# services should return html strings, or objects
# the directive is the place to process html elements, or $compile with respect to a $scope

# Services module
services_module = angular.module 'ciboulot.services', []


class BaseService extends AngularBase
    __name: 'BaseService'

    __module_install_function: (cls, module) ->
        ###
        NOTE: ServiceCls.__factory called only once
              when registred via module.service
        ###
        module.service

class BaseInstance extends AngularBase
    ###
    Same as BaseService, but __factory instantiates 
    the class
    ###

    __name: 'BaseInstance'

    __factory: (cls) ->
        new cls()

    __module_install_function: (cls, module) ->
        module.service

class PathManipulator extends BaseInstance
    __name: 'path_manipulator'

    base: (path) ->
        last_char = path[-1..]

        # This is already a folder
        if last_char == '/'
            path
        else
            # This is a file
            # take everything up to 
            # first encoutered index, including
            last_slash_index = (path.lastIndexOf '/')
            path.substring 0, last_slash_index + 1

    parent: (path) ->
        last_char = path[-1..]

        if last_char == '/'
            # This is a folder
            # remove the trailing '/'
            # this becomes a file
            # then take the base
            @base path[...-1]
        else
            # This is a file
            # take the base
            # and then the parent
            @parent (@base path)

    join_paths: (path1, path2) ->
        if path2[0..1] == "./"
            path2 = path2[2..]

            path1 = @base path1

            @join_paths path1, path2

        else if path2[0..2] == "../"
            path2 = path2[3..]

            path1 = @parent path1

            @join_paths path1, path2

        else
            "#{path1}#{path2}"

    resolve_path: (src, path) ->
        if path[0] == '/'
            path
        else
            @join_paths src, path

    id_of_path: (path) ->
        last_slash_index = path.lastIndexOf '/'

        if last_slash_index >= -1
            path = path.substring last_slash_index + 1, path.length

        "#{path}"

    filename_of_path: (path) ->
        @id_of_path path

class MarkdownService extends BaseService
    __name: 'MarkdownService'
    __injections: BaseService.prototype.__injections.concat \
        ['path_manipulator', \
         '$rootScope', \
        ]

    # XXX: $ must hence be escaped inside directives
    __NAME_ARG: '\\$\\[([\\w_-]+)( [^\\$\\n]*)?\\]'
    __TEXT: '(\\([^\\$\\n\\)]*\\))*'
    __ONE_TEXT: '\\([^\\$\\n\\)]*\\)'

    constructor: (@markdown_text, @src, @mode) ->

    initialize: () ->
        @test = 'asdf'

    process_line: (line) ->
        line

    html_of_directive: (directive) ->
        switch directive.name
            when "embed"
                path = @path_manipulator.resolve_path @src, directive.arg
                # XXX: must add ng-controller='embed' lest all embed directive 
                #      will have the same scope
                #      (i.e. ng-controller creates the new scope)
                "<span src='#{path}' ng-controller='embed' embed></span>"

            when "proc"
                path = @path_manipulator.resolve_path @src, directive.arg
                path_id = @path_manipulator.id_of_path path

                # same for mode static or display
                """<span src='#{path}' ng-controller='proc' proc>
                <a class='proc-a' href='##{path_id}'>#{directive.text[0]}</a>
                </span>"""

            when "download"
                path = @path_manipulator.resolve_path @src, directive.arg
                filename = @path_manipulator.filename_of_path directive.arg
                """<a class='download-a' href='#{path}' download='#{filename}' target='_blank'>#{directive.text[0]}</a>"""

            when "link"
                path = @path_manipulator.resolve_path @src, directive.arg
                """<a class='link-a' href='#{path}'>#{directive.text[0]}</a>"""

            when "proc-list"
                """<ul id='proc-list'></ul>"""
            when "kbd"
                separateurs = /[ +]/
                seulement_les_separateurs = directive.text[0]
                touches = directive.text[0].split separateurs
                for touche in touches
                    seulement_les_separateurs = seulement_les_separateurs.replace(touche, "")
                retour = ""

                for i in [0..seulement_les_separateurs.length]
                    touche = touches[i]
                    retour += """<kbd>#{touche}</kbd>"""
                    retour += seulement_les_separateurs.charAt(i)

                retour

            when "java", "html", "css", "xml", "bash", "ps1", "json"
                extension = directive.name
                args = directive.arg.split ' '
                path = args[0]
                path = @path_manipulator.resolve_path @src, path
                path = "#{path}.#{extension}"

                first_line = ""
                if args[1]
                    first_line = "first_line='#{args[1]}'"

                last_line = ""
                if args[2]
                    last_line = "last_line='#{args[2]}'"

                "<div class='file' src='#{path}' #{first_line} #{last_line} extension='#{extension}' file></div>"

            when "popup"

                # must create a resource and push to @rootScope.__resources
                path = "popup#{window.ciboulot['popup']}"
                window.ciboulot['popup'] += 1
                @$rootScope.__resources[path] = {   controller:directive.name, \
                                                    data: {  \
                                                            title: @src, \
                                                            text: directive.text \
                                                        } \
                                                }

                "<span class='popup' src='#{path}' popup></span>"

            else
                ""

    process_name_arg: (name_arg) ->
        directive = {name:'', \
                     arg:'', \
                     text:[]}

        name_arg_pattern = new RegExp @__NAME_ARG
        name_arg_match = name_arg.match name_arg_pattern

        if name_arg_match[1] != undefined
            directive.name = name_arg_match[1]

        if name_arg_match[2] != undefined
            directive.arg = name_arg_match[2][1..]

        text_pattern = new RegExp @__ONE_TEXT, 'g'
        text_match = name_arg.match text_pattern

        if text_match != null
            for text in text_match
                text = text.substring 1, text.length - 1
                directive.text.push text

        return @html_of_directive directive


    process_markdown_text: (markdown_text) ->
        pattern = new RegExp (@__NAME_ARG + @__TEXT), 'g'
        markdown_text.replace pattern, @process_name_arg.bind @

    install_hooks: () ->
        @converter.hooks.chain "preConversion", @process_markdown_text.bind @

    convert_html: () ->
        if @converter == undefined
            @converter = new Markdown.Converter()
            @install_hooks()

        @initialize()
        @html = @converter.makeHtml @markdown_text

    get_html: () ->
        if @html != undefined
            return @html
        else
            @convert_html()
            return @html







class FetchResourceService extends BaseService
    __name: 'FetchResourceService'

class FetchPartialService extends BaseService
    __name: 'FetchPartialService'



install_angular_cls services_module, PathManipulator
install_angular_cls services_module, MarkdownService




services_module.constant 'RESOURCE_EXTENSION', 'cib'
services_module.constant 'FETCHING', '__fetching__'

services_module.service 'fetch_resource', \
        ['$log', \
        '$http', \
        '$rootScope', \
        'RESOURCE_EXTENSION', \
        'FETCHING', \
        ($log, \
        $http, \
        $rootScope, \
        RESOURCE_EXTENSION, \
        FETCHING) ->

    (path) ->
        url = path

        if url[url.length - 1] == '/'
            url = "#{url}index"

        url = "#{url}.#{RESOURCE_EXTENSION}"

        $rootScope.__resources[path] = FETCHING

        ($http.get url).success (data, status, headers, config) ->
            $rootScope.__resources[path] = data[0]
]

services_module.service 'save_resource', \
        ['$log', \
        '$http', \
        '$rootScope', \
        'RESOURCE_EXTENSION', \
        ($log, \
       $http, \
        $rootScope, \
        RESOURCE_EXTENSION) ->

    (path) ->
        url = "#{path}.#{RESOURCE_EXTENSION}"
        $http.post url, $rootScope.__resources[path]
]

services_module.service 'fetch_partial', \
        ['$log', \
        '$http', \
        '$rootScope', \
        'FETCHING', \
        ($log, \
        $http, \
        $rootScope, \
        FETCHING) ->

    (directive, mode) ->
        url = "/__app/partials/#{directive}/#{mode}.html"
        key = "#{directive}:#{mode}"

        $rootScope.__partials[key] = FETCHING

        ($http.get url).success (data, status, headers, config) ->
            $rootScope.__partials[key] = data
]

services_module.service 'fetch_file', \
        ['$log', \
        '$http', \
        '$rootScope', \
        'FETCHING', \
        ($log, \
        $http, \
        $rootScope, \
        FETCHING) ->

    (path) ->
        url = path

        $rootScope.__files[path] = FETCHING

        ($http.get url).success (data, status, headers, config) ->
            $rootScope.__files[path] = data
]

services_module.service 'first_child_of_class', \
        ['$log', \
         ($log) ->

    first_child_of_class_rec = (elm, _class) ->
        children = []
        for child in elm.children()
            children.push (angular.element child)

        for child in children
            if child.hasClass _class
                return child

        for child in children
            result = first_child_of_class_rec child, _class
            if result != undefined
                return result

        return undefined

    return first_child_of_class_rec
]
