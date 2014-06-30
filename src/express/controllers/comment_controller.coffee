Controller = require '../lib/controller'

class CommentController extends Controller
  @secure()

  initialize : ->
    @before('create', @setLunch)

  routes:
    create: (req, res) =>
      req.lunch.addComment(req.body, req.current_user)
      res.send "ok"
      res.statusCode = 200

module.exports = new CommentController().routes

