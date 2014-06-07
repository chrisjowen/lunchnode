class @Angular
  @directive: (app, options) ->
    name = @getName().replace('Controller', '')
    name = "#{name[0].toLowerCase()}#{name.substring(1)}"
    options.controller = @
    options.templateUrl = "#{options.templateFolder||''}_#{name.toLowerCase()}.html"
    app.directive name, () -> options

  @route: (app, route) ->
    name = @getName()
    app.controller name, @
    view = "#{name.replace('Controller', '').toLowerCase()}/index.html"
    app.controller name, @
    app.config ($routeProvider) -> $routeProvider.route(route, view, name)

  @service: (app) ->
    name = @getName()
    SetArgList = (fn, args) ->
      #BEWARE, removes original arguments
      fnbody = fn.toString().replace(/^\s*function\s*[\$_a-zA-Z0-9]+\(.*\)\s*\{/, "").replace(/\s*\}\s*$/, "")
      new Function(args, fnbody)

    it = @
    wrapper = new it()
    app.factory name, SetArgList(wrapper, @.$inject)

  @inject: (args...) ->
    @$inject = args

  @getName: (name) ->
    @name || @toString().match(/function\s*(.*?)\(/)?[1]


  constructor: (args...) ->
    if @constructor.$inject?
      for key, index in @constructor.$inject
        @[key] = args[index]

    for key, fn of @constructor.prototype
      continue unless typeof fn is 'function'
      continue if key in ['constructor', 'initialize'] or key[0] is '_'
      @$scope[key] = fn.bind?(@) || _.bind(fn, @)

    if @events!=undefined
      @$scope.events = @events()

    @initialize?()
