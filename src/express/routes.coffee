module.exports = (app) ->
  app.all '/api/:controller', (req, res, next) ->
    routeMvc(req.params.controller, 'index', req, res, next)

  app.all '/api/:controller/:method', (req, res, next) ->
    routeMvc(req.params.controller, req.params.method, req, res, next)

  app.all '/api/:controller/:method/:id', (req, res, next) ->
    routeMvc(req.params.controller, req.params.method, req, res, next)

  # If all else failed, show 404 page
  app.all '/*', (req, res) ->
    console.warn "error 404: ", req.url
    res.statusCode = 404
    res.send "Not Found"

routeMvc = (controllerName, methodName, req, res, next) ->
  controllerName = 'index' if not controllerName?
  controller = null
  try
    controller = require "./controllers/" + controllerName + "_controller"
  catch e
    console.warn "controller not found: " + controllerName+ "_controller", e
    next()
    return
  data = null
  if typeof controller[methodName] is 'function'
    actionMethod = controller[methodName].bind controller
    actionMethod req, res, next
  else
    console.warn 'method not found: ' + methodName
    next()
