gardencal = (($) ->
  
  initialize = ->
    console.log "(gardencal) initialized"
    loadData()
  loadData = ->
    $.getJSON "garden.json", (data) ->
      draw(data);
  draw = (data)->
    $('.gardencal').html Mustache.render($('#template').html(), data)
    items = $ '.crops li'
    $(data.crops).each ->
      cropName = this.name
      maturation = this.maturation
      match = undefined
      $(items).each ->
        if $(this).attr('data-crop') is cropName
          match = this
      if match
        #draw crops
        topPad = 6
        i = 0
        rowHeight = 5
        $(this.plantings).each ->
          # PLANTING
          # dates are MM-DD
          startSplit = this.start.split '-'
          endSplit = this.end.split '-'
          top = (startSplit[0]-1 + startSplit[1]/30)*rowHeight
          bottom = (endSplit[0]-1 + endSplit[1]/30)*rowHeight
          $(match).append '<span class="seed" style="left: ' + (i+1) + 'rem; top:' + (top+topPad) + 'rem; height: ' + (bottom - top) + 'rem">&nbsp;</span>'
          # HARVEST
          harvestTop = top + (maturation/30)*rowHeight
          harvestBottom = bottom + (maturation/30)*rowHeight
          $(match).append '<span class="harvest" style="left: ' + (i+1) + 'rem; top: ' + (harvestTop+topPad) + 'rem; height: ' + (bottom-top) + 'rem">&nbsp;</span>'
          i++


  init: initialize
)(jQuery)
$ ->
  gardencal.init()
