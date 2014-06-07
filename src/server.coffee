app = require('./api')
port = app.port;
app.listen port,  () ->
  return console.log("Listening on #{port}\nPress CTRL-C to stop server.")

