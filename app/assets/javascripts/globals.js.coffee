define (require, exports, module) ->

  $             = require 'jquery'
  _             = require 'underscore'
  MessageCenter = require 'backbone/views/widgets/messages_view'
  UserModel     = require 'backbone/models/user_model'

  Globals =

    initialize: (options) ->
      @_bindEvents()
      @_setupAjax()
      @_setGlobalVars()

    ###
    # Public
    ###

    postGlobalSuccess: (message) ->
      @globalMessageCenter || @_getMessageCenter()
      @globalMessageCenter.clear().post(message, 'success', false).$el.hide().fadeIn(350)
      @globalMessageCenter.startFadeTimer()

    postGlobalError: (message) ->
      @globalMessageCenter || @_getMessageCenter()
      @globalMessageCenter.clear().post(message, 'error', false).$el.hide().fadeIn(350)
      @globalMessageCenter.startFadeTimer()

    ###
    # Pseudo private
    ###
    _getMessageCenter: () ->
      @globalMessageCenter = new MessageCenter(el: $('.global-message-center'))
      console.log @globalMessageCenter.el

    # Global event handling in lieu of Rails's UJS
    _bindEvents: () ->
       $(document).on('click', '.sign-out', @_signOutUser)

    # Add security tokens to all AJAX requests on site
    _setupAjax: () ->
      $.ajaxSetup
        beforeSend: (xhr, settings) ->
          return if settings.crossDomain
          return if settings.type is "GET"

          token = $('meta[name="csrf-token"]').attr('content')
          xhr.setRequestHeader('X-CSRF-Token', token) if token

    # Establish global namespace and current user if available
    _setGlobalVars: () ->
      window.LadderManager ||= {}
      window.LadderManager.currentUser = new UserModel(window.LadderManager.currentUser) if window.LadderManager.currentUser

    _signOutUser: (e) ->
      e.preventDefault() if e

      request =
        $.ajax
          url: '/users/sign_out'
          method: 'delete'

      request.success () ->
        window.location = '/users/sign_in'


