gardencal = (($) ->
  
  #rem
  topPad = 6 
  rowHeight = 5

  #containers
  crops = false

  initialize = ->
    console.log "(gardencal) initialized"
    loadData()
  loadData = ->
    $.getJSON "garden.json", (data) ->
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
    crops.css('width', data.crops.length*5.2+'rem')

  drawPlantings = (data, container) ->
    drawPlanting range, container, data for range in data.plantings.plant

  drawPlanting = (range, container, data) ->
    code = ['<span class="', '">&nbsp;</span>']

    # date and positioning gathering
    startSplit = range[0].split '-'
    endSplit = range[1].split '-'

    # planting positions
    top = (startSplit[0]-1 + startSplit[1]/30)*rowHeight
    bottom = (endSplit[0]-1 + endSplit[1]/30)*rowHeight

    # draw the main planting phase
    span = $(code[0] + 'plant' + code[1]).appendTo container
    span.css 'top', (top+topPad) + 'rem'
    span.css 'height', (bottom-top) + 'rem'
    # store its date properties in the span
    span.data 'start', range[0]
    span.data 'end', range[1]
    checkSpan span

    # harvest positioning and height
    harvestTop = (top+topPad) + data.plantings.harvest.after/30*rowHeight
    harvestBottom = (bottom+topPad) + data.plantings.harvest.after/30*rowHeight + data.plantings.harvest.for/30*rowHeight
    # draw the harvest phase
    span = $(code[0] + 'harvest' + code[1]).appendTo container
    span.css 'top', harvestTop + 'rem'
    span.css 'height', (harvestBottom - harvestTop) + 'rem'
    # store its data properties
    # planting start (04-01) + harvest.after (45)
    #harvestMonths = 
    #harvestStart = 
    #console.log 'harvest start:' + harvestStart
    #span.data 'start', harvestTop
    #span.data 'end', harve
    # check its position
    checkSpan span

    # determine optional seed phase
    if data.plantings.seedlings
      seedTop = (top+topPad) - data.plantings.seedlings/30*rowHeight
      span = $(code[0] + 'seed' + code[1]).appendTo container
      span.css 'top', seedTop + 'rem'
      span.css 'height', ((bottom+topPad) - data.plantings.seedlings/30*rowHeight - seedTop) + 'rem'
      checkSpan span

  checkSpan = (span) ->
    # if the bottom of the span is greater than (below) the bottom of the crops area
    if $(span).offset().top + $(span).outerHeight() > crops.offset().top + crops.outerHeight()
      spanTop = $(span).offset().top
      cropsTop = crops.offset().top

      #if the top of the span is below the bottom of the crops area, 
      #just move the whole thing to the proper location
      if spanTop > cropsTop + crops.outerHeight()
        diff = spanTop - (cropsTop + crops.outerHeight())
        $(span).css('top', topPad + diff/16 + 'rem')

      #otherwise, modify this span to end at the bottom of the crops area
      #and create a 2nd span to start at the top of the crops area
      else
        # @TODO handle spans that split across the new year
        console.log '@TODO handle spans that split across the new year'
        

  init: initialize
)(jQuery)
$ ->
  gardencal.init()
