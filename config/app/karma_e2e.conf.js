// Adapted from https://github.com/angular/angular-seed

module.exports = function(config){
    config.set({


    basePath : '../../',

    files : [
        'test/app/e2e/**/*.js'
    ],

    autoWatch : false,

    browsers : ['Firefox'],

    frameworks: ['ng-scenario'],

    singleRun : true,

    proxies : {
      '/': 'http://localhost:8888/'
    },

    plugins : [
            'karma-junit-reporter',
            'karma-chrome-launcher',
            'karma-firefox-launcher',
            'karma-jasmine',
            'karma-ng-scenario'
            ],

    junitReporter : {
      outputFile: 'test_out/e2e.xml',
      suite: 'e2e'
    }

})}

