$ () ->
    onload()
    
    # render ace editor
    editor = ace.edit "editor"
    editor.setTheme "ace/theme/xcode"
    editor.getSession().setUseWrapMode true
    editor.getSession().setMode "ace/mode/javascript"
    
    # load snippets
    $('#snippet-list').html template "snippets", { snippetNames: [ 
            "Original",
            "Brightness",
            "Contrast",
            "Saturation",
            "Grayscale", 
            "Black and White",
            "Sepia",
            "Posterize",
            "Blur",
            "Darken Edges",
            "Add Noise"
    ] }
    $('.snippet-link').click () ->
        snippet = $(this).data 'snippet'
        loadSnippet snippet
        
    # set up sidebar
    $('#file-sidebar').html template "files", {
        images: [
            "harvard-yard.jpg",
            "elephant.png",
            "chicken.png"
        ],
        
        scripts: [
            "run.js",
            "brightness.js",
            "grayscale.js"
        ]
    }
    $('.file-link').click () ->
        file = $(this).attr 'data-file'
        addTab file
    
    # preload images they can use
    Tripod.setSources {
        "elephant": "../images/elephant.png",
        "chicken": "../images/chicken.png",
        "harvard": "../images/harvard-yard.jpg"
        }
    
    $('#run').click () -> runInput()
    
    # run sample snippet
    loadSnippet "brightness"
    
    # load default tab
    addTab "run.js"

# Loads a sample text snippet, puts it in the editor, and executes it.    
loadSnippet = (name) ->
    name = name.toLowerCase().dasherize()
    handler = (data) ->
        # console.log data
        editor = ace.edit "editor"        
        editor.setValue data
        runInput()
    snippet = $.get "snippets/#{name}.js", handler, "text"
                    
# Initializes UI state when app is loaded.
onload = () ->
    resetOutput()
    
# Binds click and other handlers to interface elements in the output pane.
attachOutputHandlers = () ->
    $('#btn-download-image').unbind('click').bind 'click', () ->
        $(this).attr 'href', $('#main-canvas').get(0).toDataURL()
            
    # render original image, to show on top of edited one if desired
    filename = Tripod.mainImage?.image?.src
    original = $ template "original-image", { filename: filename }
    $('#canvas-holder').append original
    image = original.find 'img'
    image.attr 'width', $('#main-canvas').attr 'width'
    image.attr 'height', $('#main-canvas').attr 'height' 

    $('#view-original').unbind('click').bind 'click', () =>
        image.show()
    $('#view-edited').unbind('click').bind 'click', () =>
        image.hide()      

# Runs the inputted code.
runInput = () ->
    runButton = $('#run')
    runButton.button 'loading'
    resetOutput()
    $('#loading-modal').modal 'show'

    # wrap it in a function so they just write the body of the function
    Tripod.start $('#main-canvas'), () =>  
        editor = ace.edit "editor"
        code = editor.getValue()
        try
            eval code
            
            $('#messages').show().html template "message-success"
            
            attachOutputHandlers()
            
        catch error
            console.log error
            $('#messages').show().html template "message-error", { error: error }
        finally
            $('#loading-modal').modal 'hide'
            runButton.button 'reset'
        
# Resets the output pane.
resetOutput = () ->
    $('#console').html ''
    $('#console-holder').hide()
    $('#messages').hide()
    $('#original-image').remove()
                
# global functions

# Executes the template at assets/templates/{name}.html, passing data, and returns the HTML generated
template = (name, data) =>
    JST["assets/templates/#{name}.html"](data)

# Prints out something to the user-facing console.
log = (variable) ->
    li = $ '<li></li>'
    li.html(variable + "")
    $('#console').prepend li
    $('#console-holder').show()
    
    

startWorker = (args...) ->
    worker = new Worker "js/worker.js"
    worker.onmessage = (event) ->
        console.log event
    worker.postMessage args...