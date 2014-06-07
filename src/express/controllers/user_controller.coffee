User = require '../models/user'

module.exports =
  create: (req, res) ->
    console.log(req)
    user = new User req.body
    user.save (err, user) ->
      if not err
        req.session.current_user = user.fb_ref
        console.log req.sess
        res.send user
        res.statusCode = 201
      else
        res.send err
        res.statusCode = 500








