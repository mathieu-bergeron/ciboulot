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

# Include 'angular' (angular.js must be loaded)
angular

# The controller module
controllers_module = angular.module 'ciboulot.controllers', []

# root controller
controllers_module.controller 'root', \
                ['$log', \
                 '$scope', \
                 '$rootScope', \
                 ($log, \
                  $scope, \
                 $rootScope \
                 ) ->


        # XXX: use '__' prefix for every
        #      app specific attribute
        #
        #      the un-prefixed attributes are reserved
        #      for vars loaded from the resources

        $rootScope.__resources = {}

        # To detect cycles in embed
        $rootScope.__displayed_resources = {}

        # Partials
        $rootScope.__partials = {}

        $rootScope.__mode = 'display'

        # XXX: Angular.js already does
        #      lookup of data into parent controller scope
        #
        #      for templating, we simply need to load the appropriate data 
        #      into the local controller
        #      the data will be available to child controllers
        $scope.chiffres = ['un','deux','trois']

        # Templating test
        $scope['varname'] = 10

        # Test onload
        $rootScope.$on '$viewContentLoaded', () ->
            $log.info 'loaded'
]

# markdown controller
controllers_module.controller 'markdown', \
                ['$scope', \
                '$log', \
                '$rootScope', \
                'save_resource', \
                 ($scope, \
                 $log,  \
                 $rootScope, \
                 save_resource \
                 ) ->

        # TODO: load vars directy in the scope 
        #       that way we reuse angular.js templating

        $scope.__save_resource = (resource_id) ->
            # FIXME: this assumes the displayed_resource is still a
            #        text area
            markdown_text = $rootScope.displayed_resources[resource_id][0].value
            $rootScope.resources[resource_id]['data']['text'] = markdown_text

            save_resource resource_id
]

# steps controller
controllers_module.controller 'steps', \
                ['$scope', \
                '$log', \
                '$rootScope', \
                 ($scope, \
                 $log,  \
                 $rootScope ) ->

    $scope.current_step = 0
    $scope.steps_length = undefined

    $scope.next_step = () ->
        if $scope.current_step < ($scope.steps_length - 1)
            $scope.current_step += 1

    $scope.previous_step = () ->
        if $scope.current_step > 0
            $scope.current_step -= 1

    $scope.goto_step = (step_index) ->
        $scope.current_step = step_index
]

# steps controller
controllers_module.controller 'step', \
                ['$scope', \
                '$log', \
                '$rootScope', \
                 ($scope, \
                 $log,  \
                 $rootScope ) ->
]

# error controller
controllers_module.controller 'error', \
                ['$scope', \
                '$log', \
                '$rootScope', \
                 ($scope, \
                 $log,  \
                 $rootScope ) ->
]

# proc
controllers_module.controller 'proc', \
                ['$scope', \
                '$log', \
                '$rootScope', \
                '$location', \
                 ($scope, \
                 $log,  \
                 $rootScope, \
                 $location ) ->

    $scope.visible = false

    $scope.show = () ->
        $scope.visible = true

    $scope.hide = () ->
        $location.hash ''
        $scope.visible = false
]

# tabs
controllers_module.controller 'tabs', \
                ['$scope', \
                '$log', \
                '$rootScope', \
                '$location', \
                 ($scope, \
                 $log,  \
                 $rootScope, \
                 $location ) ->
]

# errors
controllers_module.controller 'errors', \
                ['$scope', \
                '$log', \
                '$rootScope', \
                '$location', \
                 ($scope, \
                 $log,  \
                 $rootScope, \
                 $location ) ->

    $scope.visible = false
]
