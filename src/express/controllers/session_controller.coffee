module.exports =

# Lists all lunchs
  index: (req, res) ->
    console.log(res.session)
    current_user = req.session.current_user
    if(current_user)
      res.send current_user
      res.statusCode = 201
    else
      res.statusCode = 401
      res.send ""





