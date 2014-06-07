Category = require '../models/category'
Controller = require '../lib/controller'

class CategoriesController extends Controller
  routes:
    index: (req, res) ->
      Category.find {}, (err, cat) ->
        res.send cat




module.exports = new CategoriesController().routes

