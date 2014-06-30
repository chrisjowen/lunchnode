String::toCamelCase = ->
  @replace /(\-[a-z])/g, ($1) ->
    $1.toUpperCase().replace "-", ""

String::toSnakeCase = ->
  @replace /([A-Z])/g, ($1) ->
    "_" + $1.toLowerCase()


class @Angular
  @directive: (app, options) ->
    name = @getName().replace('Controller', '')
    name = "#{name[0].toLowerCase()}#{name.substring(1)}"
    options.controller = @
    options.templateUrl = "#{options.templateFolder||''}#{name.toSnakeCase()}_directive.html" if options.templateFolder?
    app.directive name, () -> options

  @route: (app, state, url) ->
    name = @getName()
    app.controller name, @
    view = "#{state.replace(/\./g,"/")}/index.html"
    app.controller name, @
    app.config ($stateProvider) -> $stateProvider.route(state, url, view, name)

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
    @$inject = [] if not @$inject?
    for i of args
      @$inject.push(args[i])


  @secure: () ->
    @$secure = true
    @$inject.push('$location')
    @$inject.push('Auth')

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

    if(@constructor.$secure)
      if @Auth.isAuthenticated()
        @$scope.user = @Auth.account()
      else
        @Auth.checkServerSession().then((user) => @$scope.user = @Auth.account()).catch(() => @$location.path("/"))



    @$scope.$safeApply = (fn) ->
      phase = @$root.$$phase
      if phase is "$apply" or phase is "$digest"
        fn()  if fn and (typeof (fn) is "function")
      else
        @$apply fn

    @initialize?()

