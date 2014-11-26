$ () ->
    onload()
    
    # render ace editor
    editor = ace.edit "editor"
    editor.setTheme "ace/theme/xcode"
    editor.getSession().setMode "ace/mode/javascript"
    
    # preload images they can use
    Tripod.setSources {
        "elephant": "../images/elephant.png",
        "chicken": "../images/chicken.png",
        "harvard": "../images/harvard-yard.jpg"
        }
    
    runButton = $('#run')
    runButton.click () =>
        runButton.button 'loading'
        # reset debug console
        resetOutput()
        
        # wrap it in a function so they just write the body of the function
        Tripod.start () =>
            code = editor.getValue()
            try
                eval code
                $('#messages-success').show()
                $('#messages-failure').hide()
            catch error
                console.log error
                $('#messages-success').hide()
                $('#messages-failure').show()
                    .html "Line #{error.lineNumber}: #{error.message}"
            finally
                runButton.button 'reset'

# Initializes UI state when app is loaded.
onload = () ->
    console.log "Hi from Coffee"
    resetOutput()
    attachHandlers()
    
# Binds click and other handlers to interface elements.
attachHandlers = () ->
    $('#btn-download-image').unbind('click').bind 'click', () ->
        $(this).attr 'href', $('#main-canvas').get(0).toDataURL()

# Resets the output pane.
resetOutput = () ->
    $('#console').html ''
    $('#console-holder').hide()
    $('#messages-success').hide()
    $('#messages-failure').hide()    
                
# global functions

# Prints out something to the user-facing console.
log = (variable) ->
    li = $ '<li></li>'
    li.html(variable + "")
    $('#console').prepend li
    $('#console-holder').show()