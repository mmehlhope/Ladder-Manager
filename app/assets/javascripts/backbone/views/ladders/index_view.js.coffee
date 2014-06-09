define (require, exports, module) ->

  $                    = require 'jquery'
  _                    = require 'underscore'
  Backbone             = require 'backbone'
  Globals              = require 'globals'
  LadderModel          = require 'backbone/models/ladder_model'
  LadderCollection     = require 'backbone/collections/ladder_collection'
  LadderView           = require 'backbone/views/ladders/ladder_view'
  NewLadderView        = require 'backbone/views/ladders/new_view'
  MessagesView         = require 'backbone/views/widgets/messages_view'
  Ladders_t            = require 'templates/ladders/index_t'

  class LadderCollectionView extends Backbone.View

    el: '#ladders'

    events:
      'click #create-new-ladder' : 'showNewLadderForm'

    initialize: () ->
      @addChildrenAndRender()
      @listenTo(@collection, 'sync', @addChildrenAndRender)
      @listenTo(@collection, 'add', @addOne)
      this

    render: () ->
      @$el.empty().html(Ladders_t(ladders: @collection)).find('.list-view').append(@children)
      @messageCenter = new MessagesView(el: @$('.messaging:first'))
      this

    addOne: (model) ->
      ladderView = new LadderView(model: model)
      @$('.list-view').prepend(ladderView.render().el)
      # Post success message of new ladder
      Globals.postGlobalSuccess("#{model.get('name')} has been created.", 'success')
      this

    addChildrenAndRender: () ->
      @children = []

      _(@collection.models).each((model) =>
        ladderView     = new LadderView(model: model)
        ladderViewNode = ladderView.render().el
        @children.push(ladderViewNode)
      )
      @render()
      this

    toggleBusy: (el) ->
      @$(el).toggleClass('busy')
      this

    updateCollection: () ->
      @collection.fetch()
      this

    showNewLadderForm: (e) ->
      e.preventDefault()

      newladderView = new NewLadderView(
        collection: @collection
      )
      @$('.list-view').prepend(newladderView.render().el)
      @$('.list-view .list-item:first input:first').focus()
      this