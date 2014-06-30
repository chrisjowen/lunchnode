Controller = require '../lib/controller'

class InviteController extends Controller
  @secure()

  initialize : ->
    @before('create', @setLunch)

  routes:
    create: (req, res) =>
        req.lunch.invite(req.body.invitedId, req.current_user)
        res.send "ok"
        res.statusCode = 200


module.exports = new InviteController().routes

