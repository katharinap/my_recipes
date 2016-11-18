# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('textarea').each(->
    @setAttribute 'style', 'height:' + @scrollHeight + 'px;overflow-y:hidden;'
    return
  ).on 'input', ->
    @style.height = 'auto'
    @style.height = @scrollHeight + 'px'
    return

$(document).ready(ready)
$(document).on('page:load', ready)
    
