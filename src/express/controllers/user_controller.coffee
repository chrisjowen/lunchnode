User = require '../models/user'
FB = require('fb');
Controller = require '../lib/controller'

class UserController extends Controller
  @secure()

  constructor : ->
    @before  @setLunch

  userFound : (user, req, res) =>
    req.session.current_user = user
    res.send user
    res.statusCode = 201

  newUser : (req, res) =>
    FB.setAccessToken(req.body.accessToken)
    FB.api 'me', 'get', (me) ->
      user = new User
        fbId: me.id
        firstName: me['first_name']
        lastName: me['last_name']
        email: me.email
        locale: me.locale
      user.save (err, user) =>
        if not err
          @userFound(user)
        else
          res.send err
          res.statusCode = 500

  routes:
    create: (req, res) ->
      User.findOne {fbID : req.body.userID}, (err, user) =>
        if user?
          @userFound(user, req, res)
        else
          @newUser(req, res)


module.exports = new UserController().routes









