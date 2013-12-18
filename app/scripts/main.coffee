gardencal = (($) ->
  initialize = ->
    console.log "(gardencal) initialized"
    loadData()
  loadData = ->
    $.getJSON "garden.json", (data) ->
      console.log data.location + " data loaded"
      JSON = data
      draw()
  draw = ->
    

  JSON = undefined
  init: initialize
)(jQuery)
$ ->
  gardencal.init()
