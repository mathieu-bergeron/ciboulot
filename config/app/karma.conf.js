// Adapted from https://github.com/angular/angular-seed

module.exports = function(config){
    config.set({
    basePath : '../../',

    files : [
      'app/lib/angular/angular.js',
      'app/lib/angular/angular-*.js',
      'test/app/lib/angular/angular-mocks.js',
      'app/js/**/*.js',
      'test/app/unit/**/*.js'
    ],

    exclude : [
      'app/lib/angular/angular-loader.js',
      'app/lib/angular/*.min.js',
      'app/lib/angular/angular-scenario.js'
    ],

    autoWatch : true,

    frameworks: ['jasmine'],

    browsers : ['Firefox'],

    plugins : [
            'karma-junit-reporter',
            'karma-chrome-launcher',
            'karma-firefox-launcher',
            'karma-jasmine'
            ],

    junitReporter : {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    }

})}
