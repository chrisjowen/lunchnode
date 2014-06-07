Lunch = require '../models/lunch'
Controller = require '../lib/controller'

class CommentController extends Controller
  constructor : ->
#    @before  @getUser
     @before('create', @setLunch)

  setLunch: (req, res, next) =>
    Lunch.findById req.params.id, (err, lunch) =>
      if not err
        req.lunch = lunch
        next()
      else
        res.send "Lunch not found"
        res.statusCode = 404

  routes:
    create: (req, res) =>
        req.lunch.addComment(req.body)
        res.send "ok"
        res.statusCode = 200



module.exports = new CommentController().routes

