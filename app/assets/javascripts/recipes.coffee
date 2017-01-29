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

$(document).ready(ready)
$(document).on('page:load', ready)
    
