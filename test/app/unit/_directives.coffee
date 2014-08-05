'use strict'

# Test every directive

describe 'directives', () ->
    beforeEach (module 'ciboulot.directives')

    describe 'root', () ->
        it 'should print $scope.message', () ->

            module ($filterProvider) ->
                filter_constructor = () ->
                    (text) ->
                        text

                $filterProvider.register 'example_filter', filter_constructor

                return

            inject ($compile, $rootScope, $interpolate) ->
                msg = 'TEST'

                scope = $rootScope.$new()
                scope.message = 'TEST'

                elm = ($compile '<div root=""></div>') scope

                (expect elm.text()).toBe '{{ message | example_filter }}'

                scope.$apply()

                (expect elm.text()).toBe msg


