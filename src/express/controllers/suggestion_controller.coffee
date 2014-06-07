Lunch = require '../models/lunch'
Controller = require '../lib/controller'

class SuggestionController extends Controller
  constructor : ->
#    @before  @getUser
     @before  @setLunch

  setLunch: (req, res, next) =>
    Lunch.findById req.params.id, (err, lunch) =>
      if not err
        req.lunch = lunch
        next()
      else
        res.send "Lunch not found"
        res.statusCode = 404

  routes:
    create: (req, res) ->
      req.lunch.addSuggestion(req.body)
      res.send "Suggestion added"
      res.statusCode = 200

    vote: (req, res) ->
      req.lunch.voteSuggestion(req.body)
      res.send "Suggestion added"
      res.statusCode = 200



module.exports = new SuggestionController().routes

