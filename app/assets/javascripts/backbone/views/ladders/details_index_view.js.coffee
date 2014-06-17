define (require, exports, module) ->


  $                 = require 'jquery'
  _                 = require 'underscore'
  Globals           = require 'globals'
  Util              = require 'util'
  Backbone          = require 'backbone'
  Details_t         = require 'templates/ladders/details_index_t'
  MessagesView      = require 'backbone/views/widgets/messages_view'
  DetailsRenameView = require 'backbone/views/ladders/details_rename_view'

  class LadderDetailsIndexView extends Backbone.View

    el: '#ladder-settings'

    initialize: () ->
      @addChildrenAndRender()
      @listenTo(@model, 'sync', @addChildrenAndRender)
      this

    render: () ->
      @$el.empty().html(Details_t(model: @model)).find('.list-view').append(@children)
      @messageCenter = new MessagesView(el: @$('.messaging:first'))
      this

    addChildrenAndRender: () ->
      @children = []
      renameView = new DetailsRenameView(model: @model)
      @children.push(renameView.render().el)

      @render()
      this

    toggleBusy: (el) ->
      @$(el).toggleClass('busy')
      this