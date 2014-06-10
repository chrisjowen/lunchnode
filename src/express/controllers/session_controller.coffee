Controller = require '../lib/controller'

class SessionController extends Controller
  @secure()

  routes:
    index: (req, res) -> res.send req.session.current_user

module.exports = new SessionController().routes

