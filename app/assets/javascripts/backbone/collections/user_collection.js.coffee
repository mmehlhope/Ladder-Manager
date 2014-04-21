define (require, exports, module) ->

  Backbone  = require 'backbone'
  UserModel = require 'backbone/models/competitor_model'

  class UserCollection extends Backbone.Collection
    model: UserModel