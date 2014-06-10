fs = require('node-foursquare-venues')('GYQIYH2WJYWFHAOEXPME3NG5EW1JWZJLN5O5NIGFPOVN1BHF', '53P3EDKUTUQ0C0LFXFOQLBDWYS1XLY3HFHSO31E2Z021IJBM')
mongoose = require 'mongoose'
prettyjson = require('prettyjson');

mongoose.connect 'mongodb://localhost/lunchy'
User = require '../express/models/user'

FB = require('fb');

User.find {}, (err, lunchs) ->
  console.log lunchs.fb_ref
  FB.setAccessToken(lunchs.fb_ref)

FB.api 'me', 'get', (res) ->
  console.log(res)




console.log("here")

