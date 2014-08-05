'use strict'

# http://docs.angularjs.org/guide/dev_guide.e2e-testing

describe 'ciboulot', () ->
    beforeEach () ->
        browser().navigateTo '/test'

    it 'display message', () ->
        (expect ((element 'div').text())).toBe 'THE value of  "some constant"  is: 10'
