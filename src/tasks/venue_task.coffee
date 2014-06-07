fs = require('node-foursquare-venues')('GYQIYH2WJYWFHAOEXPME3NG5EW1JWZJLN5O5NIGFPOVN1BHF', '53P3EDKUTUQ0C0LFXFOQLBDWYS1XLY3HFHSO31E2Z021IJBM')
mongoose = require 'mongoose'
prettyjson = require('prettyjson');

mongoose.connect 'mongodb://localhost/lunchy'
Category = require '../express/models/category'

fs.venues.categories((err, res) ->

  res = res.response.categories.filter((it) => it.id == '4d4b7105d754a06374d81259')
  category = new Category res[0]

  category.save (err, lunch) ->
    console.log("wtf")
    if not err
      console.log("saved")
    else
      console.log("err")

  console.log "saving"
)

console.log("here")
