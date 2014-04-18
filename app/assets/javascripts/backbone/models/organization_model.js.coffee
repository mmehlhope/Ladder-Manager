define (require, exports, module) ->

  Backbone = require 'backbone'

  class OrganizationModel extends Backbone.Model

    urlRoot: '/organizations'

    has_ladders: () ->
      @get('ladders').length > 0