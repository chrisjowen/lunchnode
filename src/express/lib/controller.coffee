_ = require ('underscore')
Lunch = require '../models/lunch'


class Controller
  @secure: () ->
    @$secure = true

  before: (methods, func) =>
    if typeof(methods) == "object"
      _.each(methods, (name) => @before_one(name, func))
    else if typeof(methods) == "string"
      @before_one(methods, func)
    else if typeof(methods) ==  "function"
      func = methods
      for route of @routes
        @before_one(route, func)

  before_one: (method, func) =>
    console.log("applying #{method}, #{func}")
    m = @['routes'][method]
    @['routes'][method] = (req, res, next) =>
      req.items = {} unless req.items?
      n = () => m.call(@, req, res, next)
      func.call(@, req, res, n)

  requireUser : (req, res, next) =>
    current_user = req.session.current_user
    unless current_user
      res.statusCode = 401
      res.send 'Unauthorized'
    else
      req.current_user = current_user
      next()

  setLunch: (req, res, next) =>
    Lunch.findById req.params.id, (err, lunch) =>
      if not err
        req.lunch = lunch
        next()
      else
        res.send "Lunch not found"
        res.statusCode = 404

  constructor: (args...) ->
    @before((req, res, next) =>next())
    @before(@requireUser) if @constructor.$secure

    @initialize?()

module.exports = Controller