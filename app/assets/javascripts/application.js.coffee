require.config(
  paths:
    'bootstrap' : 'bootstrap.min'
  shim:
    'jquery_ujs': ['jquery']
    'bootstrap' : ['jquery']
)

require(['jquery', 'jquery_ujs', 'bootstrap']);