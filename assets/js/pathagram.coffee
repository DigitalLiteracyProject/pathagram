$ () ->
    console.log "Hi from Coffee"
    
    # render ace editor
    editor = ace.edit "editor"
    editor.setTheme "ace/theme/xcode"
    editor.getSession().setMode "ace/mode/javascript"
    
    # preload images they can use
    Tripod.setSources ["../images/elephant.png"] # TODO make array
    
    runButton = $('#run')
    runButton.click () =>
        runButton.button 'loading'
        # wrap it in a function so they just write the body of the function
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
            finally
                runButton.button 'reset'