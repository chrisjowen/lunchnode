#module.exports = (server) ->

fs = require('node-foursquare-venues')('GYQIYH2WJYWFHAOEXPME3NG5EW1JWZJLN5O5NIGFPOVN1BHF', '53P3EDKUTUQ0C0LFXFOQLBDWYS1XLY3HFHSO31E2Z021IJBM')

fs.categories((cats) -> console.log(cats))

#  rabbit = require("rabbit.js")
#    context = rabbit.createContext()
#    context.on "ready", ->
#    sub = context.socket "SUB"
#      routing: "topic"
#    sub.setEncoding "utf8"
#    sub.connect "lunchCreated", "" (data) ->
#      sub.on "data", (data) ->
#        socket.emit "lunch" + lunch_id,
#          data: data

