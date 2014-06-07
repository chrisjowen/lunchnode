Lunch = require '../models/lunch'
Controller = require '../lib/controller'

class LunchController extends Controller
  constructor : ->
#    @before  @getUser

  routes:
    index: (req, res) ->
      Lunch.find {}, (err, lunchs) ->
        res.send lunchs

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

    delete: (req, res) ->
      Lunch.findByIdAndRemove req.params.id, (err) ->
        if not err
          res.send {}
        else
          res.send err
          res.statusCode = 500





module.exports = new LunchController().routes

