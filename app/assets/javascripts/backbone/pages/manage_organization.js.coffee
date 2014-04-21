define (require, exports, module) ->

  $                    = require 'jquery'
  Backbone             = require 'backbone'
  OrganizationModel    = require 'backbone/models/organization_model'
  LadderCollection     = require 'backbone/collections/ladder_collection'
  LadderIndexView      = require 'backbone/views/ladders/index_view'

  class OrganizationEditPage extends Backbone.View

    el: '.organization-panel'

    initialize: (options={}) ->
      {@organization, @ladders, @users} = options

      ladderCollection  = new LadderCollection(@ladders)
      ladderIndexView   = new LadderIndexView(collection: ladderCollection)