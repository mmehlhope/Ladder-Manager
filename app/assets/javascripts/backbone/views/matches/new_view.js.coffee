define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  NewMatch_t = require 'templates/matches/new_match_t'

  class NewMatchView extends Backbone.View

    tagName: 'tr'

    events:
      'click .close-btn' : 'destroy'

    initialize: (competitor_hash={}) ->
      # @updateOtherCompetitor()
      # $('#match_competitor_1').on('change', $.proxy(@updateOtherCompetitor, this))
      @competitors = competitor_hash
      @ladder =
      this

    render: () ->
      @$el.append(NewMatch_t({competitors: @competitors, ladder: @ladder}))
      this

    updateOtherCompetitor: (e) ->
      comp_1_select = $('#match_competitor_1')
      comp_2_select = $('#match_competitor_2')

      if comp_1_select.val() isnt ""
        # Build opponent array
        opponent_hash = _.clone(@competitor_hash)
        delete opponent_hash[comp_1_select.find('option:selected').text()]
        options = []
        # Create new competitor select box excluding first selected competitor
        _.each(opponent_hash, (val, key) ->
          options.push '<option value=\"'+val+'\">'+key+'</option>'
        )
        comp_2_select.empty().prop('disabled', false)
        comp_2_select.append(options)
      else
        return false

    destroy: (e) ->
      e.preventDefault();
      this.$el.remove()