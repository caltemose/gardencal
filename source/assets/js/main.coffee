gardencal = (($) ->
  
  jsonPath = "garden-update.json"

  #flag
  currentPhase = 'all'

  #measurements in rem
  topPad = 6 
  rowHeight = 5

  #containers
  crops = false
  cropItems = false

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
    cropContainer = $ '.crops'
    # grab the crops list items
    cropItems = $ '.crops > li'

    # for all crops...
    $(data.crops).each ->
      cropName = this.name
      match = undefined

      # loop through all crop <li> to find the one that matches this crop data
      $(cropItems).each ->
        if $(this).attr('data-crop') is cropName
          match = this
      # with the matched <li>...
      if match
        drawCrop this, match

    # set the .crops container width so the list items don't wrap
    cropContainer.css('width', data.crops.length*6+'rem')

    # key links
    $('.key li').click ->
      gardencal.togglePhase $(this).find('span').attr('class')


  drawCrop = (data, container) ->
    $('h3 > a', container).click ->
      gardencal.fadeToggleCrop container
    $('label', container).click ->
      gardencal.toggleCrop container

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

    tipContent = type + ': ' + range.start + ' to ' + range.stop
    if range.notes
      tipContent += '<br>' + range.notes

    # tooltip
    span.qtip
      content: tipContent
      position:
        my: 'center left'
        at: 'center right'
      show:
        delay: 0
      hide:
        delay: 0

  fadeToggleThisCrop = (crop) ->
    #if any crop items are faded
    if $(cropItems[0]).css('opacity') < 1 or $(cropItems[1]).css('opacity') < 1
      cropItems.css('opacity', 1)
    else
      cropItems.css('opacity', 0.25)
      $(crop).css('opacity', 1)

  toggleThisCrop = (crop) ->
    #if all(ish) crop items are visible
    if $(cropItems[0]).is(':visible') and $(cropItems[1]).is(':visible')
      cropItems.hide()
      $(crop).show()
      $(window).scrollLeft(0)
    else
      cropItems.show()

  toggleThisPhase = (phase) ->
    if currentPhase is 'all'
      currentPhase = phase
      cropItems.find('span').hide()
      cropItems.find('span.' + phase).show()
    else
      cropItems.find('span').show()
      currentPhase = 'all'


  init: initialize

  fadeToggleCrop: fadeToggleThisCrop

  toggleCrop: toggleThisCrop

  togglePhase: toggleThisPhase

)(jQuery)
$ ->
  gardencal.init()
