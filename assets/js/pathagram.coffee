$ () ->
    onload()
    
    # render ace editor
    editor = ace.edit "editor"
    editor.setTheme "ace/theme/xcode"
    editor.getSession().setMode "ace/mode/javascript"
    
    # preload images they can use
    Tripod.setSources {
        "elephant": "../images/elephant.png"
                    
        }
    
    runButton = $('#run')
    runButton.click () =>
        runButton.button 'loading'
        # reset debug console
        resetConsole()
        
        # wrap it in a function so they just write the body of the function
        Tripod.start () =>
            code = editor.getValue()
            try
                eval code
                $('#messages')
                    .addClass('alert-success')
                    .removeClass('alert-danger')
                    .html "Success!"
            catch error
                console.log error
                $('#messages')
                    .addClass('alert-danger')
                    .removeClass('alert-success')
                    .html "Line #{error.lineNumber}: #{error.message}"
            finally
                runButton.button 'reset'

# Initializes UI state when app is loaded.
onload = () ->
    console.log "Hi from Coffee"
    resetConsole()
    
# Resets the debug console.
resetConsole = () ->
    $('#console').html ''
    $('#console-holder').hide()
                
# global functions

# Prints out something to the user-facing console.
log = (variable) ->
    li = $ '<li></li>'
    li.html(variable + "")
    $('#console').prepend li
    $('#console-holder').show()