define (require, exports, module) ->

  Backbone = require 'backbone'

  class CurrentUserModel extends Backbone.Model

    urlRoot: '/users'

    getFullName: () ->
      @get('name') || @get('email')

    canDeleteUser: (user) ->
      user.get('can_delete') is true
