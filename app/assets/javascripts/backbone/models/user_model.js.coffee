define (require, exports, module) ->

  Backbone = require 'backbone'

  class UserModel extends Backbone.Model

    urlRoot: '/users'

    getFullName: () ->
      @get('name') || @get('email')

    isActivated: () ->
      @get('is_activated')

    isActivatedFriendly: () ->
      if @isActivated() then 'yes' else 'no'