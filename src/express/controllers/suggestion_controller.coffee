Controller = require '../lib/controller'

class SuggestionController extends Controller
  @secure()

  initialize : ->
    @before ['create','vote'] @setLunch

  routes:
    create: (req, res) ->
      req.lunch.addSuggestion(req.body, req.current_user)
      res.send  "OK", 200

    vote: (req, res) ->
      req.lunch.vote(req.body, req.current_user)
      res.send  "OK", 200

module.exports = new SuggestionController().routes

