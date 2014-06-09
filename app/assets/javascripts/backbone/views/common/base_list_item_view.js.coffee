define (require, exports, module) ->

  $                 = require 'jquery'
  _                 = require 'underscore'
  Util              = require 'util'
  Backbone          = require 'backbone'
  Globals           = require 'globals'
  CurrentUserModel  = require 'backbone/models/current_user_model'
  MessagesView      = require 'backbone/views/widgets/messages_view'

  class BaseListItemView extends Backbone.View

    tagName: 'li'
    className: 'list-item'

    events:
      'submit .update'               : 'updateItem'
      'click [data-action="edit"]'   : 'toggleEditMode'
      'click [data-action="cancel"]' : 'toggleEditMode'
      'click [data-action="delete"]' : 'deleteItem'

    initialize: () ->
      @listenTo(@model, 'change', @render)
      @currentUser = new CurrentUserModel(window.LadderManager.currentUser) if window.LadderManager.currentUser
      @editMode    = false
      this

    render: () ->
      @messageCenter = new MessagesView(el: @$('.messaging'))
      @$('input:first').focus() if @inEditMode()
      this

    updateItem: (e) ->
      e.preventDefault()
      form = $(e.target)

      $.ajax(
        url: form.attr('action')
        type: 'PUT'
        dataType: 'json'
        data: form.serialize()
        success: (jqXHR, textStatus) =>
          # Update the model and trigger the change event whether or not it actually happens.
          # User may submit non-changing value, but view should still re-render
          @editMode = false
          @model.set(jqXHR, {silent: true})
          @model.trigger('change')
        error: (jqXHR, textStatus, errorThrown) =>
          @render()
          @$('input:first').focus()
          Globals.postGlobalError(Util.parseTransportErrors(jqXHR))
      )
      this

    deleteItem: () ->
      # delete the item

    toggleEditMode: (e) ->
      e.preventDefault() if e
      @editMode = !@editMode
      @render()
      this

    inEditMode: () ->
      @editMode

    removeEl: () ->
      @$el.slideUp(() =>
        @remove()
      )
      this
