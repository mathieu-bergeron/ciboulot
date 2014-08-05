'use strict'

# Test every controller

describe 'controllers', () ->
    beforeEach (module 'ciboulot.controllers')

    describe 'root', () ->
        it 'creates $scope.message', () ->

            module ($provide) ->
               service_constructor = () ->
                   (text) ->
                       text

               $provide.service 'example_service', service_constructor

               return

            inject ($controller) ->

                scope = {}

                root_ctrl = $controller 'root', {'$scope':scope}
                (expect root_ctrl).toBeDefined()

                (expect scope.message).toEqual ' "some constant" '


