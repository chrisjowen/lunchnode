mongoose = require 'mongoose'

CategorySchema = new mongoose.Schema(
  name:  String
  pluralName: String
  shortName:  String
  icon:
    prefix: String
    suffix: String
  categories: [CategorySchema]
)

module.exports = mongoose.model 'Category', CategorySchema