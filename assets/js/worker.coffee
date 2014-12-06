onmessage = (event) ->
    importScripts 'dependencies/sugar.js'
    importScripts 'dependencies/underscore.js'
    importScripts 'tripod.js'
    
    code = event.data
    postMessage code
    #eval code
    
    #postMessage Tripod.mainImage