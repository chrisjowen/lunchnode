Lunch = require '../models/lunch'
Controller = require '../lib/controller'

class SuggestionController extends Controller
  @secure()

  constructor : ->
     @before  @setLunch

  routes:
    create: (req, res) ->
      req.lunch.addSuggestion(req.body, req.current_user)
      res.send "Suggestion added"
      res.statusCode = 200


module.exports = new SuggestionController().routes

