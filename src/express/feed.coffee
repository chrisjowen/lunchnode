module.exports = (server) ->
    io = require('socket.io')(server);
    server.listen(process.env.RABBITMQ_BIGWIG_RX_URL )
    console.log "CONNECTING TO THE FLUFFY BUNNY"

    context = require("rabbit.js").createContext()

    context.on "ready", ->
      console.log "connected to rabbit starting listening for web socket connections"
      io.on "connection", (socket) ->
        console.log "connected to socket"

        socket.on "lunch_feed_requested", (lunch_id) ->
          console.log "lunch feed requested"
          sub = context.socket "SUB",
              routing: "topic"
            sub.setEncoding "utf8"
            sub.connect "lunch", "#.lunch#{lunch_id}.#", (data) ->
              console.log "listening for shit from lunch#{lunch_id}"

              sub.on "data", (data) ->
                socket.emit "lunch" + lunch_id,
                  data: data

