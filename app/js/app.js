// Generated by CoffeeScript 1.9.0

/*

Testing CoffeeDoc
 */

(function() {
  'use strict';
  angular;
  var ciboulot_module;

  ciboulot_module = angular.module('ciboulot', ['ciboulot.filters', 'ciboulot.services', 'ciboulot.directives', 'ciboulot.controllers']);

  ciboulot_module.config([
    '$locationProvider', function($locationProvider) {
      return $locationProvider.html5Mode(true);
    }
  ]);

}).call(this);
