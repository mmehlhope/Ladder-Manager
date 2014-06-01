define (require, exports, module) ->

  Backbone  = require 'backbone'
  UserModel = require 'backbone/models/user_model'

  class UserCollection extends Backbone.Collection
    model: UserModel
    url: "/admin/users"