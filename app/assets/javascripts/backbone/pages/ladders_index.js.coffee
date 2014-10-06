define (require, exports, module) ->

  $                  = require 'jquery'
  Backbone           = require 'backbone'
  OrganizationModel  = require 'backbone/models/organization_model'
  LadderCollection   = require 'backbone/collections/ladder_collection'
  LadderIndexView    = require 'backbone/views/ladders/index_view'

  class LaddersIndexPage extends Backbone.View

    initialize: (options={}) ->
      {@organization, @ladders} = options
      ladderCollection = new LadderCollection(@ladders)
      ladderIndexView  = new LadderIndexView(
        collection: ladderCollection
        organization: new OrganizationModel(@organization)
      )
