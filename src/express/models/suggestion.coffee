mongoose = require 'mongoose'
pushToRabbitPlugin = require './pushToRabbitPlugin'

# Post model
Suggestion = new mongoose.Schema(
  venue_id: String
  user_name: String
  user_email : String
)
Suggestion.plugin pushToRabbitPlugin, {type : 'Suggestion'}

module.exports = mongoose.model 'Suggestion', Suggestion