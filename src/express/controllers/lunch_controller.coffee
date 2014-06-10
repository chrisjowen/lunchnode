Lunch = require '../models/lunch'
Controller = require '../lib/controller'

class LunchController extends Controller
  @secure()

  initialize : ->
    @before('invited', @setLunch)

  routes:
    index: (req, res) ->
      Lunch.find {}, (err, lunch) ->
        res.send lunch

    create: (req, res) ->
      lunch = new Lunch req.body
      lunch.save (err, lunch) ->
        if not err
          res.send lunch
          res.statusCode = 201
        else
          res.send err
          res.statusCode = 500

    get: (req, res) ->
      Lunch.findById req.params.id, (err, lunch) ->
        if not err
          res.send lunch
        else
          res.send err
          res.statusCode = 500

    update: (req, res) ->
      Lunch.findByIdAndUpdate req.params.id, {"$set":req.body}, (err, lunch) ->
        if not err
          res.send lunch
        else
          res.send err
          res.statusCode = 500

    invited: (req, res) ->
      req.lunch.getInvitedUsers((err, users) =>
        if not err
          res.send users
        else
          res.send err
          res.statusCode = 500
      )





module.exports = new LunchController().routes

