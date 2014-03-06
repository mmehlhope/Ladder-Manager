define (require, exports, module) ->

  $                         = require 'jquery'
  _                         = require 'underscore'
  Backbone                  = require 'backbone'
  CompetitorModel           = require 'backbone/models/competitor_model'
  CompetitorCollection      = require 'backbone/collections/competitor_collection'
  CompetitorView            = require 'backbone/views/competitors/competitor_view'
  NewCompetitorView         = require 'backbone/views/competitors/new_view'
  MessagesView              = require 'backbone/views/widgets/messages_view'
  Competitors_t             = require 'templates/competitors/index_t'

  class CompetitorCollectionView extends Backbone.View

    el: '#competitors'

    events:
      'click #create-new-competitor' : 'showNewCompetitorForm'

    initialize: () ->
      @addChildrenAndRender()
      @listenTo(@collection, 'sync', @addChildrenAndRender)
      @listenTo(@collection, 'add', @addOne)
      this

    render: () ->
      @$el.empty().html(Competitors_t(competitors: @collection)).find('.list-view').append(@children)
      @messageCenter = new MessagesView(el: @$('.messaging:first'))
      this

    addOne: (model) ->
      competitorView = new CompetitorView(model: model)
      @$('.list-view').prepend(competitorView.render().el)
      # Post success message of new competitor
      @messageCenter.post("#{model.get('name')} has been added to the ladder.", 'success')
      this

    addChildrenAndRender: () ->
      @children = []

      _(@collection.models).each((model) =>
        competitorView     = new CompetitorView(model: model)
        competitorViewNode = competitorView.render().el
        @children.push(competitorViewNode)
      )
      @render()
      this

    toggleBusy: (el) ->
      @$(el).toggleClass('busy')
      this

    updateCollection: () ->
      @collection.fetch()
      this

    showNewCompetitorForm: (e) ->
      e.preventDefault()

      newCompetitorView = new NewCompetitorView(
        collection  : @collection
        url         : @collection.url
        _view       : @
      )
      @$('.list-view').prepend(newCompetitorView.render().el)
      this