mongoose = require 'mongoose'
rabbitExpress = require './rabbitExpress'

CommentSchema  = new mongoose.Schema
  userId: String,
  at: Date,
  body: String

SuggestionSchema  = new mongoose.Schema
  userId: String,
  at: Date,
  identifier: String

LunchSchema = new mongoose.Schema(
  title: {type: String, required: true}
  comments: [CommentSchema]
  suggestions: [SuggestionSchema]
)

InviteSchema = new mongoose.Schema(
  userId: String,
  invitedId: String,
  at: Date
)



LunchSchema.methods =
  addComment : (comment, user) ->
    comment._id = mongoose.Types.ObjectId()
    comment.at = new Date()
    comment.userId = user._id
    this.model('Lunch').update({_id: this._id}, {$push: {comments: comment}}, {upsert: true}, (err, data) =>
      rabbitExpress.push(this.id, "comment", comment)
      err
    )
  addSuggestion : (suggestion, user) ->
    suggestion._id = mongoose.Types.ObjectId()
    suggestion.at = new Date()
    suggestion.userId = user._id
    this.model('Lunch').update({_id: this._id}, {$push: {suggestions: suggestion}}, {upsert: true}, (err, data) =>
      rabbitExpress.push(this.id, "suggestion", suggestion)
      err
    )
  invite: (invitedId, user) ->
    invite = {}
    invite._id = mongoose.Types.ObjectId()
    invite.at = new Date()
    invite.userId = user._id
    invite.invitedId = user.invitedId
    this.model('Lunch').update({_id: this._id}, {$push: {invites: invite}}, {upsert: true}, (err, data) =>
      rabbitExpress.push(this.id, "invite", invite)
      err
    )
  getInvitedUsers: (func) ->
    this.model('User').find({}, func)

#Post.plugin pushToRabbitPlugin, {type : 'Post'}

module.exports = mongoose.model 'Lunch', LunchSchema