define (require, exports, module) ->

  $               = require 'jquery'
  _               = require 'underscore'
  Backbone        = require 'backbone'
  UserModel       = require 'backbone/models/user_model'
  UserCollection  = require 'backbone/collections/user_collection'
  UserView        = require 'backbone/views/users/user_view'
  NewUserView     = require 'backbone/views/users/new_view'
  MessagesView    = require 'backbone/views/widgets/messages_view'
  Users_t         = require 'templates/users/index_t'

  class UserCollectionView extends Backbone.View

    el: '#users'

    events:
      'click #create-new-user' : 'showNewUserForm'

    initialize: () ->
      @addChildrenAndRender()
      @listenTo(@collection, 'sync', @addChildrenAndRender)
      @listenTo(@collection, 'add', @addOne)
      this

    render: () ->
      @$el.empty().html(Users_t(users: @collection)).find('.list-view').append(@children)
      @messageCenter = new MessagesView(el: @$('.messaging:first'))
      this

    addOne: (model) ->
      userView = new UserView(model: model)
      @$('.list-view').prepend(userView.render().el)
      # Post success message of new user
      @messageCenter.clear().post("#{model.get('name')} has been created.", 'success')
      this

    addChildrenAndRender: () ->
      @children = []

      _(@collection.models).each((model) =>
        userView     = new UserView(model: model)
        userViewNode = userView.render().el
        @children.push(userViewNode)
      )
      @render()
      this

    toggleBusy: (el) ->
      @$(el).toggleClass('busy')
      this

    updateCollection: () ->
      @collection.fetch()
      this

    showNewUserForm: (e) ->
      e.preventDefault()
      newUserView = new NewUserView(
        collection      : @collection
      )
      @$('.list-view').prepend(newUserView.render().el)
      this