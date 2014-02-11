define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  NewMatch_t = require 'templates/matches/new_match_t'

  class NewMatchView extends Backbone.View

    tagName: 'tr'

    events:
      'click .close-btn'                   : 'destroy'
      'submit form'                        : 'createMatch'
      'change [name="match-competitor-1"]' : 'updateOtherCompetitor'

    initialize: (params) ->
      @competitors = params['competitors']
      @ladder_id   = params['ladder']
      this

    render: () ->
      @$el.append(NewMatch_t({competitors: @competitors, ladder: @ladder}))
      this

    updateOtherCompetitor: (e) ->
      comp_1_select = @$el.find('select[name="match-competitor-1"]')
      comp_2_select = @$el.find('select[name="match-competitor-2"]')
      if comp_1_select.val() isnt ""
        # Build opponent array
        opponent_hash = @createOpponentHash()

        # Create new competitor select box excluding user-selected competitor
        options = []
        _.each(opponent_hash, (competitor) ->
          options.push '<option value=\"'+competitor.id+'\">'+competitor.name+'</option>'
        )
        comp_2_select.empty().append(options).prop('disabled', false)
      else
        return false

    createOpponentHash: () ->
      comp_1_select      = @$el.find('select[name="match-competitor-1"]')
      selectedCompetitor = parseInt(comp_1_select.find('option:selected').val()) # Convert to number for equality
      opponent_hash      = _.clone(@competitors)
      opponent_hash      = _(opponent_hash).reject((competitor) -> # Return all competitors except selected one
                            return competitor.id is selectedCompetitor
                            )
      opponent_hash

    createMatch: (e) ->
      e.preventDefault()

      $.ajax(
        url: '/matches/' + @model.get('id') + '/finalize'
        type: 'POST'
        dataType: 'json'
        success: (jqXHR, textStatus) =>
          @destroy()
        error: (jqXHR, textStatus, errorThrown) ->
          console.log textStatus
      )
      this

    destroy: (e) ->
      e.preventDefault()
      this.$el.remove()
      this