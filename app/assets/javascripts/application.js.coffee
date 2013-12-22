require.config(
  shim:
    'jquery_ujs': ['jquery']
)

require ['jquery', 'jquery_ujs'], ($) ->

  $ ->
    console.log 'jquery loaded'