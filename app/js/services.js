// Generated by CoffeeScript 1.6.3
(function() {
  'use strict';
  angular;
  Markdown;
  var AngularBase, BaseInstance, BaseService, FetchPartialService, FetchResourceService, MarkdownService, PathManipulator, install_angular_cls, services_module, _ref, _ref1, _ref2, _ref3, _ref4,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  AngularBase = window.ciboulot['AngularBase'];

  install_angular_cls = window.ciboulot['install_angular_cls'];

  services_module = angular.module('ciboulot.services', []);

  BaseService = (function(_super) {
    __extends(BaseService, _super);

    function BaseService() {
      _ref = BaseService.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    BaseService.prototype.__name = 'BaseService';

    BaseService.prototype.__module_install_function = function(cls, module) {
      /*
      NOTE: ServiceCls.__factory called only once
            when registred via module.service
      */

      return module.service;
    };

    return BaseService;

  })(AngularBase);

  BaseInstance = (function(_super) {
    __extends(BaseInstance, _super);

    function BaseInstance() {
      _ref1 = BaseInstance.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    /*
    Same as BaseService, but __factory instantiates 
    the class
    */


    BaseInstance.prototype.__name = 'BaseInstance';

    BaseInstance.prototype.__factory = function(cls) {
      return new cls();
    };

    BaseInstance.prototype.__module_install_function = function(cls, module) {
      return module.service;
    };

    return BaseInstance;

  })(AngularBase);

  PathManipulator = (function(_super) {
    __extends(PathManipulator, _super);

    function PathManipulator() {
      _ref2 = PathManipulator.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    PathManipulator.prototype.__name = 'path_manipulator';

    PathManipulator.prototype.join_paths = function(path1, path2) {
      var last_slash_index;
      last_slash_index = path1.lastIndexOf('/');
      path1 = path1.substring(0, last_slash_index + 1);
      if (path2.slice(0, 2) === "./") {
        path2 = path2.slice(2);
      }
      return "" + path1 + path2;
    };

    PathManipulator.prototype.resolve_path = function(src, path) {
      if (path[0] === '/') {
        return path;
      } else {
        return this.join_paths(src, path);
      }
    };

    PathManipulator.prototype.id_of_path = function(path) {
      var last_slash_index;
      last_slash_index = path.lastIndexOf('/');
      if (last_slash_index >= -1) {
        path = path.substring(last_slash_index + 1, path.length);
      }
      return "" + path;
    };

    PathManipulator.prototype.filename_of_path = function(path) {
      return this.id_of_path(path);
    };

    return PathManipulator;

  })(BaseInstance);

  MarkdownService = (function(_super) {
    __extends(MarkdownService, _super);

    MarkdownService.prototype.__name = 'MarkdownService';

    MarkdownService.prototype.__injections = BaseService.prototype.__injections.concat(['path_manipulator']);

    MarkdownService.prototype.__NAME_ARG = '\\$\\[([\\w_-]+)( [^\\$\\n]*)?\\]';

    MarkdownService.prototype.__TEXT = '(\\([^\\$\\n\\)]*\\))*';

    MarkdownService.prototype.__ONE_TEXT = '\\([^\\$\\n\\)]*\\)';

    function MarkdownService(markdown_text, src, mode) {
      this.markdown_text = markdown_text;
      this.src = src;
      this.mode = mode;
    }

    MarkdownService.prototype.initialize = function() {
      return this.test = 'asdf';
    };

    MarkdownService.prototype.process_line = function(line) {
      return line;
    };

    MarkdownService.prototype.html_of_directive = function(directive) {
      var filename, path, path_id;
      switch (directive.name) {
        case "embed":
          path = this.path_manipulator.resolve_path(this.src, directive.arg);
          return "<span src='" + path + "' embed></span>";
        case "proc":
          path = this.path_manipulator.resolve_path(this.src, directive.arg);
          path_id = this.path_manipulator.id_of_path(path);
          return "<span src='" + path + "' ng-controller='proc' proc>\n<a class='proc-a' href='#" + path_id + "'>" + directive.text[0] + "</a>\n</span>";
        case "download":
          path = this.path_manipulator.resolve_path(this.src, directive.arg);
          filename = this.path_manipulator.filename_of_path(directive.arg);
          return "<a class='download-a' href='" + path + "' download='" + filename + "' target='_blank'>" + directive.text[0] + "</a>";
        case "proc-list":
          return "<ul id='proc-list'></ul>";
        default:
          return "";
      }
    };

    MarkdownService.prototype.process_name_arg = function(name_arg) {
      var directive, name_arg_match, name_arg_pattern, text, text_match, text_pattern, _i, _len;
      directive = {
        name: '',
        arg: '',
        text: []
      };
      name_arg_pattern = new RegExp(this.__NAME_ARG);
      name_arg_match = name_arg.match(name_arg_pattern);
      if (name_arg_match[1] !== void 0) {
        directive.name = name_arg_match[1];
      }
      if (name_arg_match[2] !== void 0) {
        directive.arg = name_arg_match[2].slice(1);
      }
      text_pattern = new RegExp(this.__ONE_TEXT, 'g');
      text_match = name_arg.match(text_pattern);
      if (text_match !== null) {
        for (_i = 0, _len = text_match.length; _i < _len; _i++) {
          text = text_match[_i];
          text = text.substring(1, text.length - 1);
          directive.text.push(text);
        }
      }
      return this.html_of_directive(directive);
    };

    MarkdownService.prototype.process_markdown_text = function(markdown_text) {
      var pattern;
      pattern = new RegExp(this.__NAME_ARG + this.__TEXT, 'g');
      return markdown_text.replace(pattern, this.process_name_arg.bind(this));
    };

    MarkdownService.prototype.install_hooks = function() {
      return this.converter.hooks.chain("preConversion", this.process_markdown_text.bind(this));
    };

    MarkdownService.prototype.convert_html = function() {
      if (this.converter === void 0) {
        this.converter = new Markdown.Converter();
        this.install_hooks();
      }
      this.initialize();
      return this.html = this.converter.makeHtml(this.markdown_text);
    };

    MarkdownService.prototype.get_html = function() {
      if (this.html !== void 0) {
        return this.html;
      } else {
        this.convert_html();
        return this.html;
      }
    };

    return MarkdownService;

  })(BaseService);

  FetchResourceService = (function(_super) {
    __extends(FetchResourceService, _super);

    function FetchResourceService() {
      _ref3 = FetchResourceService.__super__.constructor.apply(this, arguments);
      return _ref3;
    }

    FetchResourceService.prototype.__name = 'FetchResourceService';

    return FetchResourceService;

  })(BaseService);

  FetchPartialService = (function(_super) {
    __extends(FetchPartialService, _super);

    function FetchPartialService() {
      _ref4 = FetchPartialService.__super__.constructor.apply(this, arguments);
      return _ref4;
    }

    FetchPartialService.prototype.__name = 'FetchPartialService';

    return FetchPartialService;

  })(BaseService);

  install_angular_cls(services_module, PathManipulator);

  install_angular_cls(services_module, MarkdownService);

  services_module.constant('RESOURCE_EXTENSION', 'cib');

  services_module.constant('FETCHING', '__fetching__');

  services_module.service('fetch_resource', [
    '$log', '$http', '$rootScope', 'RESOURCE_EXTENSION', 'FETCHING', function($log, $http, $rootScope, RESOURCE_EXTENSION, FETCHING) {
      return function(path) {
        var url;
        url = path;
        if (url[url.length - 1] === '/') {
          url = "" + url + "index";
        }
        url = "" + url + "." + RESOURCE_EXTENSION;
        $rootScope.__resources[path] = FETCHING;
        return ($http.get(url)).success(function(data, status, headers, config) {
          return $rootScope.__resources[path] = data[0];
        });
      };
    }
  ]);

  services_module.service('save_resource', [
    '$log', '$http', '$rootScope', 'RESOURCE_EXTENSION', function($log, $http, $rootScope, RESOURCE_EXTENSION) {
      return function(path) {
        var url;
        url = "" + path + "." + RESOURCE_EXTENSION;
        return $http.post(url, $rootScope.__resources[path]);
      };
    }
  ]);

  services_module.service('fetch_partial', [
    '$log', '$http', '$rootScope', 'FETCHING', function($log, $http, $rootScope, FETCHING) {
      return function(directive, mode) {
        var key, url;
        url = "/__app/partials/" + directive + "/" + mode + ".html";
        key = "" + directive + ":" + mode;
        $rootScope.__partials[key] = FETCHING;
        return ($http.get(url)).success(function(data, status, headers, config) {
          return $rootScope.__partials[key] = data;
        });
      };
    }
  ]);

  services_module.service('first_child_of_class', [
    '$log', function($log) {
      var first_child_of_class_rec;
      first_child_of_class_rec = function(elm, _class) {
        var child, children, result, _i, _j, _k, _len, _len1, _len2, _ref5;
        children = [];
        _ref5 = elm.children();
        for (_i = 0, _len = _ref5.length; _i < _len; _i++) {
          child = _ref5[_i];
          children.push(angular.element(child));
        }
        for (_j = 0, _len1 = children.length; _j < _len1; _j++) {
          child = children[_j];
          if (child.hasClass(_class)) {
            return child;
          }
        }
        for (_k = 0, _len2 = children.length; _k < _len2; _k++) {
          child = children[_k];
          result = first_child_of_class_rec(child, _class);
          if (result !== void 0) {
            return result;
          }
        }
        return void 0;
      };
      return first_child_of_class_rec;
    }
  ]);

}).call(this);
