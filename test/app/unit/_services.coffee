'use strict'

# Test every service

describe 'services', () ->
    beforeEach (module 'ciboulot.services')

    describe 'example constant', () ->
        it 'should be 10.0', inject (EXAMPLE_CONSTANT) ->
            (expect EXAMPLE_CONSTANT).toEqual 10.0

    describe 'example service', () ->
        it 'should construct a message', inject (example_service) ->
            (expect (example_service 'T')).toEqual "The value of T is: 10"

