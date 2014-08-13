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

# Include 'fabric' (lib/fabric/all.js must be loaded)
fabric

# Directives module
directives_module = angular.module 'ciboulot.directives', ['ciboulot.services']

# Ciboulot globals
AngularBase = window.ciboulot['AngularBase']
install_angular_cls = window.ciboulot['install_angular_cls']

# Directive class
class BaseDirective extends AngularBase
    __name: 'BaseDirective'
    __injections: AngularBase.prototype.__injections.concat \
        ['$compile']

    constructor: () ->

    link: (scope, elm, attrs, controller) ->
        @$scope = scope
        @$elm = elm
        @$attrs = attrs
        @$controller = controller

    __factory: (cls) ->
        ###
        Return a link function that 
        instantiates the DiretiveCls on each call
        ###

        link = (scope, elm, attrs, controller) ->
            directive_obj = new cls()
            return directive_obj.link scope, elm, attrs, controller

        {link: link}

    __module_install_function: (cls, module) ->
        module.directive


# Error 
class ErrorDirective extends BaseDirective
    __name: 'error'

    link: (scope, elm, attrs, controller) ->
        super scope, elm, attrs, controller

        msg = "resource not found: #{@$elm.attr 'src'}"

        @$elm.text msg

# Directive class
class ResourceDirective extends BaseDirective
    __name : 'resource'
    __injections: BaseDirective.prototype.__injections.concat \
        ['$rootScope', \
        'fetch_resource', \
        'FETCHING']

    link: (scope, elm, attrs, controller) ->
        super scope, elm, attrs, controller
        @resource_id = elm.attr 'src'

        # When passing a method as a function,
        # must bind the function so it gets called with this == owner object
        # (otherwise this refers to the function object itself)
        #
        #
        @$scope.$watch @get_resource.bind(@), @on_resource_watcher.bind(@)

    get_resource: () ->
        @resource = @$rootScope.__resources[@resource_id]
        @resource

    on_resource_watcher: (resource, old_resource) ->
        if resource == undefined
            @fetch_resource @resource_id
        else if resource != @FETCHING
            @on_resource()

    on_resource: () ->
        @display()

    display: () ->
        ###
        Append resource to @$elm
        ###
        @$elm.empty()

        cntl = @resource.controller

        resource_elm = angular.element "<div class='#{@__name}' ng-controller='#{cntl}' src='#{@resource_id}' #{cntl}=''></div>"
        resource_elm = (@$compile resource_elm) @$scope

        @$elm.append resource_elm


class EmbedDirective extends ResourceDirective
    __name: 'embed'

    detect_embed_loop: () ->
        # XXX: if data_id is already displayed, do nothing
        #      there is a loop in embeds
        @resource_id of @$rootScope.__displayed_resources

    display_embed_loop: () ->
        embed_warning = angular.element "<div>Embed loop detected for #{@resource_id}</div>"
        embed_warning = (@$compile embed_warning) @$scope

        @$elm.empty()
        @$elm.append embed_warning

    display: () ->
        if @detect_embed_loop()
            @display_embed_loop()

        super()

class ModeDirective extends ResourceDirective
    __name: 'mode'

    ###
    Watches:
        * resource
        * mode
    ###

    get_mode: () ->
        @mode = @$rootScope.__mode
        return @mode

    on_mode_watcher: (mode, old_mode) ->
        @mode = mode
        @on_mode()

    on_mode: () ->
        @display()

    on_resource: () ->
        # When resource changes, re-install the mode watcher
        # or perhaps check if it is installed
        if @destroy_mode_watcher != undefined
            @destroy_mode_watcher()

        @destroy_mode_watcher = @$scope.$watch @get_mode.bind(@), @on_mode_watcher.bind(@)

class PartialDirective extends ModeDirective
    __name: 'partial'
    __injections: ModeDirective.prototype.__injections.concat \
        ['fetch_partial', \
         'FETCHING']

    ###
    Watches:
        * resource
        * mode
        * partial
    ###

    get_partial: () ->
        @partial = @$rootScope.__partials["#{@__name}:#{@mode}"]
        return @partial

    on_partial_watcher: (partial, old_partial) ->
        if partial == undefined
            @fetch_partial @__name, @mode
        else if partial != @FETCHING
            @on_partial()

    on_partial: () ->
        @display()

    on_mode: () ->
        # When mode changes, re-install the partial watcher
        if @destroy_partial_watcher != undefined
            @destroy_partial_watcher()

        @destroy_partial_watcher = @$scope.$watch @get_partial.bind(@), @on_partial_watcher.bind(@)

class MarkdownDirective extends PartialDirective
    __name: 'markdown'
    __injections: PartialDirective.prototype.__injections.concat \
        ['first_child_of_class', \
        'MarkdownService']
    ###
    Wait for resource, mode, and partial
    ###

    display: () ->
        # When resource, mode and partial are available
        markdown_text = @resource['data']['text']

        # Save to scope; this is necessary to compile partials
        @$scope.markdown_text = markdown_text
        @$scope.resource_id = @resource_id

        @$elm.empty()
        compiled_html = (@$compile @partial) @$scope
        @$elm.append compiled_html

        markdown_elm = undefined
        markdown_elm = @first_child_of_class @$elm, 'markdown'

        @$rootScope.__displayed_resources[@resource_id] = compiled_html

        if (@mode == 'display' or @mode == 'static') and markdown_elm != undefined

            markdown_service = new @MarkdownService markdown_text, @resource_id, @mode

            # NOTE: markdown_service will
            #       also contains accumulated info about the article, 
            #       e.g. the TOC

            markdown_html = markdown_service.get_html()

            compiled_markdown = (@$compile markdown_html) @$scope

            markdown_elm.append compiled_markdown

class ProcDirective extends PartialDirective
    __name: 'proc'
    __injections: PartialDirective.prototype.__injections.concat \
        ['first_child_of_class']

    watch_visible: () -> @$scope.visible

    on_visible_watcher: (visible, old_visible) ->
        @on_visible()

    on_visible: () ->
        if @$scope.visible
            @show()
        else
            @hide()

    show: () ->
        @cover_elm.css 'display', 'block'
        @partial_elm.css 'display', 'block'

    hide: () ->
        @cover_elm.css 'display', 'none'
        @partial_elm.css 'display', 'none'

        # Notify the child scope
        @$scope.$broadcast 'hide'

    display: () ->
        @cover_elm = angular.element "<div class='cover'></div>"
        @partial_elm = angular.element "<div ng-click='hide();' class='proc-partial'></div>"
        @partial_elm = (@$compile @partial_elm) @$scope

        # install the proc div
        compiled_partial = (@$compile @partial) @$scope

        @partial_elm.append compiled_partial

        @$elm.append @cover_elm
        @$elm.append @partial_elm

        steps_div = @first_child_of_class @partial_elm, 'steps'

        @steps_elm = "<div src='#{@resource_id}' embed></div>"
        @steps_elm = (@$compile @steps_elm) @$scope

        steps_div.append @steps_elm

        # watch for visibility
        @$scope.$watch (@watch_visible.bind @), (@on_visible_watcher.bind @)

    display_static: () ->
        ###
        Link to first of a series of steps panels
        append to procs_div
        ###

        procs_div = angular.element (document.getElementById 'procs')

        @partial_elm = angular.element "<div></div>"

        # install the proc div
        compiled_partial = (@$compile @partial) @$scope

        @partial_elm.append compiled_partial

        procs_div.append @partial_elm

        steps_div = @first_child_of_class @partial_elm, 'steps'

        @steps_elm = "<div src='#{@resource_id}' ng-controller='steps' steps></div>"
        @steps_elm = (@$compile @steps_elm) @$scope

        steps_div.append @steps_elm


    on_partial: () ->
        switch @mode
            when 'static'
                @display_static()
            else
                @display()


class StepsDirective extends PartialDirective
    __name: 'steps'
    __injections: PartialDirective.prototype.__injections.concat \
        ['MarkdownService',  \
         'path_manipulator' ]

    step_watcher: () -> @$scope.current_step

    on_step_watcher: (step, old_step) ->
        @on_step()

    on_step:() ->
        @hide_all_steps()
        @show_current_step()

    hide_all_steps: () ->
        for step_elm in @step_elms
            step_elm.css 'display', 'none'

    on_parent_hide: () ->
        if @$scope.default_step != undefined
            @$scope.current_step = @$scope.default_step
        else
            @$scope.current_step = 0

    show_current_step: () ->
       @step_elms[@$scope.current_step].css 'display', 'block'

    install_partial: () ->
        # Install/display all the steps
        compiled_html = (@$compile @partial) @$scope
        @$elm.append compiled_html

    display_title: () ->
        title = @resource['data']['title']
        converter = new @MarkdownService title, @resource_id, @mode

        title_html = (@$compile converter.get_html()) @$scope

        title_html.addClass 'step-title'
        title_html.addClass 'proc-button'

        @$elm.append title_html

        return title_html

    display_steps: () ->
        @step_elms = []

        # is there a default step
        default_step = @resource['data']['default'][0]

        for step, i in @resource['data']['steps']
            step_path = @path_manipulator.resolve_path @resource_id, step

            @$scope.step_indices[step_path] = i
            @$scope.step_titles.push undefined

            if step == default_step
                @$scope.default_step = i
                @$scope.current_step = i

            html = "<div src='#{step_path}' embed></div>"
            compiled_html = (@$compile html) @$scope
            @$elm.append compiled_html
            @step_elms.push compiled_html

    display_steps_static: () ->
        @step_elms = []

        # is there a default step
        default_step = @resource['data']['default'][0]

        for step, i in @resource['data']['steps']
            id = @$scope.default_id
            if step == default_step
                @$scope.default_step = i
                @$scope.current_step = i
            else
                id = "#{id}-#{i}"

            # Install title for each step
            title_html = @display_title()
            title_html.attr 'id', id
            title_html.addClass 'title-static'

            title_html.append "&nbsp;&nbsp;&nbsp;&nbsp;<a href=''>⇫</a>"

            step_path = @path_manipulator.resolve_path @resource_id, step

            @$scope.step_indices[step_path] = i
            @$scope.step_titles.push undefined

            html = "<div src='#{step_path}' embed></div>"
            compiled_html = (@$compile html) @$scope
            @$elm.append compiled_html
            @step_elms.push compiled_html


    display: () ->
        @install_partial()
        @display_title()
        @display_steps()

        # Watch step
        @$scope.$watch (@step_watcher.bind @), (@on_step_watcher.bind @)

        # Listen for parent 'hide' event
        @$scope.$on 'hide', (@on_parent_hide.bind @)

    display_static: () ->
        @install_partial()
        @display_steps_static()

    on_partial: () ->
        # steps_length
        @$scope.steps_length = @resource['data']['steps'].length

        # Save data to parent scope
        # Each <step> might display it
        @$scope.step_titles = []
        @$scope.step_indices = {}
        @$scope.default_step = 0
        @$scope.default_id = @path_manipulator.id_of_path @resource_id

        switch @mode
            when 'static'
                @display_static()
            else
                @display()

class StepDirective extends ModeDirective
    __name: 'step'
    __injections: ModeDirective.prototype.__injections.concat \
        ['MarkdownService', \
        'path_manipulator' ]

    set_canvas_id: () ->
        @canvas_id = @resource_id
        @canvas_id = @canvas_id[1..]
        @canvas_id = @canvas_id.replace /\//g, '-'
        if @mode == 'static'
            @canvas_id = "#{@canvas_id}"
        else
            @canvas_id = "#{@canvas_id}-#{@$scope.$id}"

    add_canvas_note: (note) ->
        switch note['type']
            when 'text'
                text = note['text']
                top = note['top']
                left = note['left']
                if 'background' of note
                    background = note['background']
                else
                    background = 'black'
                if 'fill' of note
                    fill = note['fill']
                else
                    fill = 'red'
                if 'fontSize' of note
                    fontSize = note['fontSize']
                else
                    fontSize = 22
                if 'fontWeight' of note
                    fontWeight = note['fontWeight']
                else
                    fontWeight = 'bold'

                text = new fabric.Text text, { top: top, left: left, textBackgroundColor:background, fill:fill, fontSize:fontSize, fontWeight: fontWeight}
                @canvas.add text

            when 'box'
                top = note['top']
                left = note['left']
                width = note['width']
                heigth = note['height']
                if 'stroke' of note
                    stroke = note['stroke']
                else
                    stroke = 'red'
                if 'background_stroke' of note
                    background_stroke = note['background_stroke']
                else
                    background_stroke = 'black'

                background_rect = new fabric.Rect {top:top, left:left, width:width, height:heigth, stroke:background_stroke, strokeWidth:5, fill:'transparent', opacity:0.9}
                rect = new fabric.Rect {top:top, left:left, width:width, height:heigth, stroke:stroke, strokeWidth:5, fill:'transparent', strokeDashArray:[5,5], opacity:1.0}
                @canvas.add background_rect
                @canvas.add rect

    add_canvas_notes: () ->
        for note in @image['notes']
            @add_canvas_note note

    scale_image: () ->
        if @image.width > @canvas.width
            @image.scaleToWidth @canvas.width

        if @image.height > @canvas.height
            @image.scaleToHeight @canvas.height

        if (@image.width * @image.scaleX) < @canvas.width
            @image.set {left:(@canvas.width - @image.width*@image.scaleX) / 2}


    add_image: () ->
        @canvas.add @image
        @canvas.sendToBack @image

    image_fetcher: (image) ->
        @image = image
        @scale_image()
        @add_image()

    populate_canvas: () ->
        @image = @resource['data']['image']
        img_src = @path_manipulator.resolve_path @resource_id, @image['src']

        # Fetch image
        fabric.Image.fromURL img_src, @image_fetcher.bind @

        # Add notes
        @add_canvas_notes()

    step_titles_watcher: () ->
        for step_title in @$scope.$parent.step_titles
            if step_title == undefined
                return false

        return true

    on_step_titles: (ready, old_ready) ->
        if ready
            @display()

    on_mode: () ->
        title = @resource['data']['title']
        converter = new @MarkdownService title, @resource_id
        @title_html = (@$compile converter.get_html()) @$scope

        # Cover the case where there is no parent scope
        if @$scope.$parent.step_indices == undefined
            @$scope.$parent.step_indices = {}
            @$scope.$parent.step_indices[@resource_id] = 0

        if @$scope.$parent.step_titles == undefined
            @$scope.$parent.step_titles = [undefined]

        if @$scope.$parent.default_step == undefined
            @$scope.$parent.default_step = 0

        @step_index = @$scope.$parent.step_indices[@resource_id]
        @$scope.$parent.step_titles[@step_index] = @title_html

        if @destroy_step_titles_watcher != undefined
            @destroy_step_titles_watcher()

        @destroy_step_titles_watcher = @$scope.$watch (@step_titles_watcher.bind @), (@on_step_titles.bind @)

    display: () ->
        step_titles = [@title_html.clone()]

        if @$scope.$parent.step_titles != undefined
            step_titles = @$scope.$parent.step_titles

        ol = angular.element "<ol></ol>"
        for step_title, step_index in step_titles
            li = angular.element "<li></li>"
            li.addClass 'step-enum'

            if step_index == @step_index
                li.addClass 'current-step'
            else
                li.addClass 'not-current-step'

            if @mode == 'display'
                a = angular.element "<a href='' class='step-a' ng-click='goto_step(#{step_index});'></a>"
                a = (@$compile a) @$scope
            else if @mode == 'static'
                href = "##{@$scope.$parent.default_id}"
                if step_index != @$scope.$parent.default_step
                    href = "#{href}-#{step_index}"

                a = angular.element "<a href='#{href}' class='step-a'></a>"

            if step_title != undefined
                a.append step_title.clone()
            else
                a.append "&nbsp;"

            li.append a
            ol.append li

        @$elm.append ol

        # Add image
        @set_canvas_id()
        canvas_html = "<canvas  width='650px' height='356px' id='#{@canvas_id}'></canvas>"

        @$elm.append canvas_html

        # Fabric.js canvas
        # in ?mode=edit, use a regular Canvas
        @canvas = new fabric.StaticCanvas @canvas_id

        # Add image
        @populate_canvas()

class RootDirective extends ResourceDirective
    __name: 'root'
    __injections: ResourceDirective.prototype.__injections.concat \
        ['$location']

    get_path: () ->
        @path = @$location.path()
        return @path

    on_path_watcher: (path, old_path) ->
        @path = path
        @on_path()

    on_path: () ->
        ###
        Re-initialize and watch resource
        ###
        @$rootScope.__displayed_resources = {}

        # resource
        @resource_id = @path

        # XXX: must destroy resource watcher, elm is never destroyed
        if @destroy_resource_watcher != undefined
            @destroy_resource_watcher()

        # Now watch and display resource
        @destroy_resource_watcher = @$scope.$watch (@get_resource.bind @), (@on_resource_watcher.bind @)

    get_search: () ->
        @search = @$location.search()
        return @search

    on_search_watcher: (search, old_search) ->
        @search = search
        @on_search()

    on_search: () ->
        if 'edit' of @search
            @$rootScope.__mode = 'edit'
        if 'static' of @search
            @$rootScope.__mode = 'static'
        else
            @$rootScope.__mode = 'display'

    link: (scope, elm, attrs, controller) ->
        ###
        Avoid ResourceDirective.link, which starts with resource watcher
        ###
        ResourceDirective.__super__.link.call @, scope, elm, attrs, controller

        # Watch path and search
        @$scope.$watch @get_path.bind(@), @on_path_watcher.bind(@)
        @$scope.$watch @get_search.bind(@), @on_search_watcher.bind(@)

class TabsDirective extends PartialDirective
    __name: 'tabs'
    __injections: PartialDirective.prototype.__injections.concat \
        ['first_child_of_class',
         'path_manipulator',
         'MarkdownService']

    display: () ->
        # XXX: would be elegant to push @resource['data'] into @$scope
        #      and use angular.js templating in partial .html file
        #      but this is has to be "reconciled" with markdown compilation
        #      perhaps a InlineMarkdownDirective (?)

        compiled_partial = (@$compile @partial) @$scope
        @$elm.append compiled_partial

        tabs_title = @first_child_of_class @$elm, 'tabs-title'
        tabs = @first_child_of_class @$elm, 'tabs'
        tab_text = @first_child_of_class @$elm, 'tab-text'

        title_html = (new @MarkdownService @resource['data']['title'], @resource_id, @mode).get_html()
        tabs_title.append title_html


        for tab in @resource['data']['tabs']
            tab_title_html = (new @MarkdownService tab['title'], @resource_id, @mode).get_html()
            new_tab = angular.element "<span class='proc-button tab'></span>"
            new_tab.append tab_title_html
            tabs.append new_tab

            if 'text' of tab
                tab_text_html = (new @MarkdownService tab['text'], @resource_id, @mode).get_html()
                new_tab_text = angular.element "<spann class='tab-text'></span>"
                new_tab_text.append tab_text_html

                tab_text.append new_tab_text

            else if 'embed' of tab
                embed_html = "<div src=#{@path_manipulator.resolve_path @resource_id, tab['embed']} embed></div>"
                compiled_embed = (@$compile embed_html) @$scope
                tab_text.append compiled_embed

class ErrorsDirective extends ModeDirective
    __name: 'errors'
    __injections: ModeDirective.prototype.__injections.concat \
        ['first_child_of_class',
         'MarkdownService']

    display: () ->
        for pair in @resource['data']
            error_html = (new @MarkdownService pair['error'], @resource_id, @mode).get_html()
            solution_html = (new @MarkdownService pair['solution'], @resource_id, @mode).get_html()

            @$elm.append error_html
            @$elm.append solution_html

install_angular_cls directives_module, EmbedDirective
install_angular_cls directives_module, MarkdownDirective
install_angular_cls directives_module, RootDirective
install_angular_cls directives_module, ErrorDirective
install_angular_cls directives_module, StepsDirective
install_angular_cls directives_module, StepDirective
install_angular_cls directives_module, ProcDirective
install_angular_cls directives_module, TabsDirective
install_angular_cls directives_module, ErrorsDirective
