define (require, exports, module) ->

  Backbone = require 'backbone'

  class CurrentUserModel extends Backbone.Model

    urlRoot: '/users'

    getFullName: () ->
      @get('name') || @get('email')

    canDelete: (id) ->
      !(@get('id') is id)