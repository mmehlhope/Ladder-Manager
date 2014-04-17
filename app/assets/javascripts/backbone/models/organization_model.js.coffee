define (require, exports, module) ->

  Backbone = require 'backbone'

  class OrganizationModel extends Backbone.Model

    urlRoot: '/organizations'