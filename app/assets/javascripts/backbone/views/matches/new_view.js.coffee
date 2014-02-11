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

      @updateOtherCompetitor()
      this

    render: () ->
      @$el.append(NewMatch_t({competitors: @competitors, ladder: @ladder}))
      this

    updateOtherCompetitor: (e) ->
      comp_1_select = @$el.find('select[name="match-competitor-1"]')
      comp_2_select = @$el.find('select[name="match-competitor-2"]')

      if comp_1_select.val() isnt ""
        # Build opponent array
        opponent_hash = _.clone(@competitors)
        delete opponent_hash[comp_1_select.find('option:selected').text()]
        options = []
        # Create new competitor select box excluding first selected competitor
        _.each(opponent_hash, (competitor) ->
          options.push '<option value=\"'+competitor.id+'\">'+competitor.name+'</option>'
        )
        comp_2_select.empty().prop('disabled', false)
        comp_2_select.append(options)
      else
        return false

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