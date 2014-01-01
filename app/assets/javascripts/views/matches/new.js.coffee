define ['jquery', 'underscore'], ($, _) ->

  NewMatch =
    init: (competitor_hash) ->
      @competitor_hash = competitor_hash
      @updateOtherCompetitor()
      $('#match_competitor_1').on('change', $.proxy(@updateOtherCompetitor, this))
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
      this
