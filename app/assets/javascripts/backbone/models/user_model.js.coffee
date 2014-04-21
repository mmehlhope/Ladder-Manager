define (require, exports, module) ->

  Backbone = require 'backbone'

  class UserModel extends Backbone.Model

    urlRoot: '/users'