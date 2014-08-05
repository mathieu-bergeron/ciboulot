'use strict'

# Test every directive

describe 'filters', () ->
    beforeEach (module 'ciboulot.filters')

    describe 'example_filter', () ->
        it 'should replace The with THE', inject (example_filterFilter) ->
            (expect (example_filterFilter 'The')).toEqual 'THE'

