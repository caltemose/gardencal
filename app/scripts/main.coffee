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
          # DATES
          startSplit = this.start.split '-'
          endSplit = this.end.split '-'

          # PLANTING
          top = (startSplit[0]-1 + startSplit[1]/30)*rowHeight
          bottom = (endSplit[0]-1 + endSplit[1]/30)*rowHeight
          span =  $('<span class="seed">&nbsp;</span>').appendTo match
          span.data 'start', this.start
          span.data 'end', this.end
          span.css 'left', (i+1) + 'rem'
          span.css 'top', (top+topPad) + 'rem'
          span.css 'height', (bottom-top) + 'rem'
          span.qtip
            content: 'Seed: ' + this.start + ' to ' + this.end
            position:
              my: 'center left'
              at: 'center right'
            show:
              delay: 0
            hide:
              delay: 0

          # HARVEST
          harvestTop = top + (maturation/30)*rowHeight
          harvestBottom = bottom + (maturation/30)*rowHeight
          span =  $('<span class="harvest">&nbsp;</span>').appendTo match
          span.data 'start', this.start
          span.data 'end', this.end
          span.css 'left', (i+1) + 'rem'
          span.css 'top', (harvestTop+topPad) + 'rem'
          span.css 'height', (bottom-top) + 'rem'
          span.qtip
            content: 'Harvest: ' + this.start + ' to ' + this.end
            position:
              my: 'center left'
              at: 'center right'
            show:
              delay: 0
            hide:
              delay: 0          

          #$(match).append '<span class="harvest" style="left: ' + (i+1) + 'rem; top: ' + (harvestTop+topPad) + 'rem; height: ' + (bottom-top) + 'rem">&nbsp;</span>'

          i++


  init: initialize
)(jQuery)
$ ->
  gardencal.init()
