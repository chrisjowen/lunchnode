mongoose = require 'mongoose'
rabbitExpress = require './rabbitExpress'

User  = new mongoose.Schema
  fbId: {type: String, required: true}
  firstName: String
  lastName: String
  email: String
  locale: String

CommentSchema  = new mongoose.Schema
  user: Object,
  at: Date,
  body: String

SuggestionSchema  = new mongoose.Schema
  user: Object,
  at: Date,
  identifier: String,
  category: Object,
  name: String,
  rating: String
  location: Object

VoteSchema = new mongoose.Schema
  user: Object,
  at: Date,
  direction: Number,
  suggestionIdentifier: String

LunchSchema = new mongoose.Schema
  title: {type: String, required: true}
  location: Object
  time: String
  comments: [CommentSchema]
  suggestions: [SuggestionSchema]
  votes: [VoteSchema]
  radius: Number

InviteSchema = new mongoose.Schema
  user: Object,
  invitedId: String,
  at: Date

MiniUserSchema = new mongoose.Schema
  email: {type: String, required: true}
  name: {type: String, required: true}
  userId: {type: String, required: true}

CategorySchema = new mongoose.Schema
  name:  String
  pluralName: String
  shortName:  String
  icon:
    prefix: String
    suffix: String
  categories: [CategorySchema]

MiniUser = mongoose.model 'MiniUser', MiniUserSchema






addMeta = (item, user) =>
  item._id = mongoose.Types.ObjectId()
  item.at = new Date()
  item.user = new MiniUser
    email : user.email
    name: "#{user.firstName} #{user.lastName}"
  item


LunchSchema.methods =
    addComment : (comment, user) ->
      this.model('Lunch').update {_id: this._id},{$push: {comments: addMeta(comment, user)}},{upsert: true},(err, data) =>
        rabbitExpress.push(this.id, "comments", comment)
        err

    addSuggestion : (suggestion, user) ->
      this.model('Lunch').update {_id: this._id}, {$push: {suggestions:  addMeta(suggestion, user)}}, {upsert: true}, (err, data) =>
        rabbitExpress.push(this.id, "suggestions", suggestion)
        err

    vote: (vote, user) ->
      this.model('Lunch').update {_id: this._id}, {$push: {votes:  addMeta(vote, user)}}, {upsert: true}, (err, data) =>
        rabbitExpress.push(this.id, "votes", vote)
        err

    invite: (invitedId, user) ->
      invite = addMeta({}, user)
      invite.invitedId = user.invitedId
      this.model('Lunch').update {_id: this._id}, {$push: {invites: invite}}, {upsert: true}, (err, data) =>
        rabbitExpress.push(this.id, "invites", invite)
        err

    getInvitedUsers: (func) ->
      this.model('User').find({}, func)


Lunch: mongoose.model 'Lunch', LunchSchema
Category: mongoose.model 'Category', CategorySchema
User: mongoose.model 'User', User