# auto-resize textarea fields (taken from
# http://stackoverflow.com/questions/454202/creating-a-textarea-with-auto-resize)
ready = ->
  $('textarea').each(->
    @setAttribute 'style', 'height:' + @scrollHeight + 'px;overflow-y:hidden;'
    return
  ).on 'input', ->
    @style.height = 'auto'
    @style.height = @scrollHeight + 'px'
    return

  $('#rating').raty(
    score: -> $(this).attr('data-score'),
    starType: 'i',
    click: (score, evt) ->
      $.ajax(
        url: '/ratings/' + $(this).attr('data-rating-id'),
        type: 'PATCH',
        data: { rating: { score: score } }
      )
  )

  $('.rating-read-only').raty(
    score: -> $(this).attr('data-score'),
    starType: 'i',
    readOnly: true
  )
    
$(document).ready(ready)
$(document).on('page:load', ready)
    
