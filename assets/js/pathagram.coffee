$ () ->
    console.log "Hi from Coffee"
    
    # render ace editor
    editor = ace.edit "editor"
    editor.setTheme "ace/theme/xcode"
    editor.getSession().setMode "ace/mode/javascript"
    
    Tripod.setSources ["../images/elephant.png"]
    
    $('#run').click () =>
        Tripod.start () =>            
            code = editor.getValue()
            try
                eval code
                $('#console')
                    .addClass('alert-success')
                    .removeClass('alert-danger')
                    .html "Success!"
            catch error
                console.log error
                $('#console')
                    .addClass('alert-danger')
                    .removeClass('alert-success')
                    .html "Line #{error.lineNumber}: #{error.message}"