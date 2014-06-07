Controller = require '../lib/controller'
fs = require('node-foursquare-venues')('GYQIYH2WJYWFHAOEXPME3NG5EW1JWZJLN5O5NIGFPOVN1BHF', '53P3EDKUTUQ0C0LFXFOQLBDWYS1XLY3HFHSO31E2Z021IJBM')

class VenueController extends Controller
  constructor : ->


  routes:
    search: (req, res) =>
      fs.venues.explore req.body.criteria, (err, results) =>
        items = results.response.groups[0].items


        res.send JSON.stringify(items.map (item) =>
            venue = item.venue
            item =
              name : venue.name
              location: venue.location
              id: venue.id
              likes: venue.likes.count
              tips: venue.stats.tipCount
            item
        )


module.exports = new VenueController().routes

