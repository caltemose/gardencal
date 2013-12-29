gardencal = (($) ->
  
  jsonPath = "garden-update.json"

  #rem
  topPad = 6 
  rowHeight = 5

  #containers
  crops = false

  initialize = ->
    console.log "(gardencal) initialized"
    loadData()

  loadData = ->
    $.getJSON jsonPath, (data) ->
      console.log "JSON loaded"
      draw(data);

  draw = (data)->
    # render calendar/info section and crop headers
    $('.gardencal').html Mustache.render($('#template').html(), data)
    crops = $ '.crops'
    # grab the crops list items
    items = $ '.crops li'
    # for all crops...
    $(data.crops).each ->
      cropName = this.name
      match = undefined
      # loop through all crop <li> to find the one that matches this crop data
      $(items).each ->
        if $(this).attr('data-crop') is cropName
          match = this
      # with the matched <li>...
      if match
        drawPlantings this, match

    # set the .crops container width so the list items don't wrap
    crops.css('width', data.crops.length*6+'rem')

  drawPlantings = (data, container) ->
    #drawPlanting range, container, data for range in data.plantings.plant
    drawPlanting planting, container for planting in data.plantings

  drawPlanting = (planting, container) ->
    code = ['<span class="', '">&nbsp;</span>']
    # planting
    if planting.plant
      drawSpan planting.plant, "plant", container
    # transplant
    if planting.transplant
      drawSpan planting.transplant, "transplant", container
    # harvest
    drawSpan planting.harvest, "harvest", container    

  drawSpan = (range, type, container) ->
    code = ['<span class="', '">&nbsp;</span>']

    # date and positioning gathering
    startSplit = range.start.split '-'
    stopSplit = range.stop.split '-'

    # planting positions
    top = (startSplit[0]-1 + startSplit[1]/30)*rowHeight
    bottom = (stopSplit[0]-1 + stopSplit[1]/30)*rowHeight

    # draw the main planting phase
    span = $(code[0] + type + code[1]).appendTo container
    span.css 'top', (top+topPad) + 'rem'
    span.css 'height', (bottom-top) + 'rem'

    # store its date properties in the span
    span.data 'start', range.start
    span.data 'end', range.stop

    # tooltip
    span.qtip
      content: type + ': ' + range.start + ' to ' + range.stop
      position:
        my: 'center left'
        at: 'center right'
      show:
        delay: 0
      hide:
        delay: 0




  init: initialize
)(jQuery)
$ ->
  gardencal.init()
