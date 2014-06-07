_ = require ('underscore')

class Controller
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
    console.log(method)
    m = @['routes'][method]
    @['routes'][method] = (req, res, next) =>
      req.items = {} unless req.items?
      n = () => m(req, res, next)
      func(req, res, n)

  getUser : (req, res, next) =>
    current_user = req.session.current_user
    unless current_user
      res.statusCode = 401
      res.send 'Unauthorized'
    else
      @current_user = current_user
      next()


module.exports = Controller