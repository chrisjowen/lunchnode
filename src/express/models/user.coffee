mongoose = require 'mongoose'
User  = new mongoose.Schema(
  fbId: {type: String, required: true}
  firstName: String
  lastName: String
  email: String
  locale: String
)
module.exports = mongoose.model 'User', User
