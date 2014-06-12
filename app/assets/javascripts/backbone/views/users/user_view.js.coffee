define (require, exports, module) ->

  $                 = require 'jquery'
  _                 = require 'underscore'
  Util              = require 'util'
  Backbone          = require 'backbone'
  User_t            = require 'templates/users/user_t'
  BaseListItemView  = require 'backbone/views/common/base_list_item_view'

  class UserView extends BaseListItemView

    render: () ->
      @$el.html(User_t(user: @model, _view: @, currentUser: @currentUser))
      super

    deleteItem: (e) ->
      e.preventDefault() if e

      if confirm("Are you sure you want to delete #{@model.get('name')}?")
        @model.destroy(
          success: () =>
            @removeEl()
          error: (existingModel, response) =>
            @messageCenter.post(Util.parseTransportErrors(response), 'danger', false)
        )

    currentUserHighlight: () ->
      if @currentUser.get('id') is @model.get('id') then 'info-bg' else ''
