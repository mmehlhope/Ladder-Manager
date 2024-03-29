define (require, exports, module) ->

  $                    = require 'jquery'
  _                    = require 'underscore'
  Util                 = require 'util'
  Backbone             = require 'backbone'
  NewMatch_t           = require 'templates/matches/new_match_t'
  MatchModel           = require 'backbone/models/match_model'
  CompetitorCollection = require 'backbone/collections/competitor_collection'

  class NewMatchView extends Backbone.View

    tagName: 'li'
    className: 'list-item bordered'

    events:
      'submit form'                         : 'createMatch'
      'change [name="match[competitor_1]"]' : 'updateOtherCompetitor'
      'click [data-action="close"]'         : 'removeEl'

    initialize: (options={}) ->
      @ladder_id   = options.ladder_id
      @contextView = options.contextView
      @competitors = @getCompetitors()
      this

    render: () ->
      # Only render after competitors have been fetched
      $.when(@competitors).done(() =>
        @$el.html(NewMatch_t({competitors: @competitors, ladder_id: @ladder_id}))
      )
      this

    getCompetitors: () ->
      competitorCollection     = new CompetitorCollection
      competitorCollection.url = "/ladders/#{@ladder_id}/competitors"
      competitorCollection.fetch(
        success: (collection, response, options) =>
          @trigger('fetchFinished')
          @competitors = collection.models
        error: (collection, response, options) =>
          @contextView.messageCenter.post(Util.parseTransportErrors(response), 'danger')
      )

    updateOtherCompetitor: (e) ->
      comp_1_select = @$el.find('select[name="match[competitor_1]"]')
      comp_2_select = @$el.find('select[name="match[competitor_2]"]')
      if comp_1_select.val() isnt ""
        # Build opponent array
        opponent_hash = @createOpponentHash()

        # Create new competitor select box excluding user-selected competitor
        options = []
        _.each(opponent_hash, (competitor) ->
          options.push '<option value=\"'+competitor.get("id")+'\">'+competitor.get("name")+'</option>'
        )
        comp_2_select.empty().append(options).prop('disabled', false)
      else
        return false

    createOpponentHash: () ->
      comp_1_select      = @$el.find('select[name="match[competitor_1]"]')
      selectedCompetitor = parseInt(comp_1_select.find('option:selected').val()) # Convert to number for equality
      opponent_hash      = _.clone(@competitors)
      opponent_hash      = _(opponent_hash).reject((competitor) -> # Return all competitors except selected one
                            return competitor.get('id') is selectedCompetitor
                            )
      opponent_hash

    createMatch: (e) ->
      e.preventDefault()
      form = $(e.target)

      $.ajax(
        url: form.attr('action')
        type: 'POST'
        dataType: 'json'
        data: form.serialize()
        success: (jqXHR, textStatus) =>
          @removeEl()
          @collection.push(jqXHR)
        error: (jqXHR, textStatus, errorThrown) =>
          @contextView.messageCenter.post(Util.parseTransportErrors(jqXHR), 'danger')
      )
      this

    removeEl: (e) ->
      e.preventDefault() if e
      @remove()
      this
