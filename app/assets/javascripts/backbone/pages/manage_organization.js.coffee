define (require, exports, module) ->

  $                  = require 'jquery'
  Backbone           = require 'backbone'
  OrganizationModel  = require 'backbone/models/organization_model'
  LadderCollection   = require 'backbone/collections/ladder_collection'
  LadderIndexView    = require 'backbone/views/ladders/index_view'
  UserCollection     = require 'backbone/collections/user_collection'
  UserIndexView      = require 'backbone/views/users/index_view'

  class OrganizationEditPage extends Backbone.View

    el: '.organization-panel'

    initialize: (options={}) ->
      {@organization, @ladders, @users} = options
      orgModel         = new OrganizationModel(@organization)
      ladderCollection = new LadderCollection(@ladders)
      ladderIndexView  = new LadderIndexView(collection: ladderCollection, organization: orgModel)
      userCollection   = new UserCollection(@users)
      userIndexView    = new UserIndexView(collection: userCollection)
