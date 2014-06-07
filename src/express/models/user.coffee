mongoose = require 'mongoose'
User  = new mongoose.Schema(
  fb_ref: {type: String, required: true}
)
module.exports = mongoose.model 'User', User
