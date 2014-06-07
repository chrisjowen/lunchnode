mongoose = require 'mongoose'
rabbitExpress = require './rabbitExpress'

CommentSchema  = new mongoose.Schema
  email: String,
  at: Date,
  body: String

SuggestionSchema  = new mongoose.Schema
  email: String,
  at: Date,
  identifier: String

LunchSchema = new mongoose.Schema(
  title: {type: String, required: true}
  comments: [CommentSchema]
  suggestions: [SuggestionSchema]
)

LunchSchema.methods =
  addComment : (comment) ->
    comment._id = mongoose.Types.ObjectId()
    comment.at = new Date()
    this.model('Lunch').update({_id: this._id}, {$push: {comments: comment}}, {upsert: true}, (err, data) =>
      rabbitExpress.push(this.id, "comment", comment)
      err
    )
  addSuggestion : (suggestion) ->
    suggestion._id = mongoose.Types.ObjectId()
    suggestion.at = new Date()
    this.model('Lunch').update({_id: this._id}, {$push: {suggestions: suggestion}}, {upsert: true}, (err, data) =>
      rabbitExpress.push(this.id, "suggestion", suggestion)
      err
    )




#Post.plugin pushToRabbitPlugin, {type : 'Post'}

module.exports = mongoose.model 'Lunch', LunchSchema