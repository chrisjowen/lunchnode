Controller = require '../lib/controller'
fs = require('node-foursquare-venues')('GYQIYH2WJYWFHAOEXPME3NG5EW1JWZJLN5O5NIGFPOVN1BHF', '53P3EDKUTUQ0C0LFXFOQLBDWYS1XLY3HFHSO31E2Z021IJBM')

class VenueController extends Controller
  @secure()

  constructor : ->
    @before  @setLunch

  getSuggestion: (id, found, error) =>
    fs.venues.venue id, {}, (err, result) =>
      if err==null
        found(result.response.venue)
      else
        error(err)

  search: (criteria, found, error) =>
    fs.venues.explore criteria,  (err, results) =>
      if err==null
        items = results.response.groups[0].items
        found(items.map((it) => it.venue))
      else
        error(err)

  routes:
    search: (req, res) ->
      @search(req.body.criteria, ((venues) => res.send venues, 200), ((err)=> res.send err, 500))
    index: (req, res) ->
      @getSuggestion(req.params.id, ((venue) => res.send venue, 200), ((err)=> res.send err, 500))

module.exports = new VenueController().routes

