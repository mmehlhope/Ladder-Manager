define (require, exports, module) ->

  $ = require 'jquery'

  Globals =

    initialize: (options) ->
      @bindEvents()
      @setupAjax()
      @setGlobalVars()

    # Global event handling in lieu of Rails's UJS
    bindEvents: () ->
       $(document).on('click', '.sign-out', @_signOutUser)

    # Add security tokens to all AJAX requests on site
    setupAjax: () ->
      $.ajaxSetup
        beforeSend: (xhr, settings) ->
          return if settings.crossDomain
          return if settings.type is "GET"

          token = $('meta[name="csrf-token"]').attr('content')
          xhr.setRequestHeader('X-CSRF-Token', token) if token

    setGlobalVars: () ->
      window.LadderManager ||= {}
      window.LadderManager.currentUser = new UserModel(window.LadderManager.currentUser) if window.LadderManager.currentUser

    ###
    # Pseudo private
    ###
    _signOutUser: (e) ->
      e.preventDefault() if e

      request =
        $.ajax
          url: '/users/sign_out'
          method: 'delete'

      request.success () ->
        window.location = '/users/sign_in'


