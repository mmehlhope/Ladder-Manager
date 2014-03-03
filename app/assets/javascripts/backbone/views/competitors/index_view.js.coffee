define (require, exports, module) ->

  $                         = require 'jquery'
  _                         = require 'underscore'
  Backbone                  = require 'backbone'
  CompetitorModel           = require 'backbone/models/competitor_model'
  CompetitorCollection      = require 'backbone/collections/competitor_collection'
  CompetitorView            = require 'backbone/views/competitors/competitor_view'
  # NewCompetitorView         = require 'backbone/views/competitors/new_view'
  MessagesView              = require 'backbone/views/widgets/messages_view'
  Competitors_t             = require 'templates/competitors/index_t'

  class CompetitorCollectionView extends Backbone.View

    el: '#competitors'

    events:
      'click #record-new-competitor' : 'showNewCompetitorForm'

    initialize: () ->
      @addChildrenAndRender()
      @messageCenter = new MessagesView(el: @$('.messaging:first'))

      @listenTo(@collection, 'sync', @addChildrenAndRender)
      @listenTo(@collection, 'add', @addOne)
      this

    render: () ->
      @$el.empty().html(Competitors_t(competitors: @collection)).find('.list-view').append(@children)
      this

    addOne: (model) ->
      competitorView     = new CompetitorView(model: model)
      competitorViewNode = competitorView.render().el
      @$('.list-view').prepend(competitorViewNode)
      # Post success message of new competitor
      # @messageCenter.post(
      #   "You've added a new competitor between #{model.get('competitor_1').name} and #{model.get('competitor_2').name}!",
      #   'success'
      # )
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

    toggleBusy: () ->
      @$('#record-new-competitor').toggleClass('busy')
      this

    updateCollection: () ->
      @collection.fetch()
      this

    showNewCompetitorForm: (e) ->
      e.preventDefault()
      @toggleBusy()

      newCompetitorView = new NewCompetitorView(
        collection  : @collection
        ladder_id   : @collection.ladder_id
      )
      @listenTo(newCompetitorView, 'fetchFinished', @toggleBusy)
      @$('.list-view').prepend(newCompetitorView.render().el)
      this