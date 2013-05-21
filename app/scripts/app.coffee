# The JS app for the radio
require.config
  baseUrl: "/scripts/"
  paths:
    jquery: "../components/jquery/jquery"
    underscore: "../components/underscore/underscore"
    backbone: "../components/backbone/backbone"
    mustache: "../components/mustache/mustache"
    when: "../components/when/when"
    soundcloudSdk: "//connect.soundcloud.com/sdk"

  shim:
    soundcloudSdk:
      exports: "SC"

    underscore:
      exports: "_"

    backbone:
      deps: ["underscore", "jquery"]
      exports: "Backbone"



define ['jquery', 'underscore', 'smoothie/modules/soundcloud', 'smoothie/controllers/radio_controller'], \

       ($, _, Soundcloud, RadioController) ->


  "use strict"

  window.App = {

    # The container
    container: $('#main-container .container')


    # The landing page
    renderLanding: () ->
      $.get 'templates/landing.html', (template) =>
        @container.html(template)


    # The radio page
    renderRadio: (userId) ->
      $.get 'templates/radio.html', (template) =>
        @container.html(radio)
        RadioController.initialize userId: userId


    # The login logic
    login: () ->
      SC.connect () =>
        SC.get '/me', (user) =>
          this.renderRadio(user.id)
  }

  $ ->

    Soundcloud.initialize()

    App.renderLanding()