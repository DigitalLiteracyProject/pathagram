console.log "Welcome to Tripod"

class TPixel
    constructor: (@canvas, @x, @y, @red, @green, @blue, alpha = 255) ->
        @alpha = alpha
    
    setRed: (red) ->
        @red = Math.round red
        @draw()
        
    getRed: -> @red
        
    setGreen: (green) ->
        @green = Math.round green        
        @draw()
        
    getGreen: -> @green
        
    setBlue: (blue) ->
        @blue = Math.round blue        
        @draw()
        
    getBlue: -> @blue
        
    setAlpha: (alpha) ->
        @alpha = Math.round alpha        
        @draw()
        
    getAlpha: -> @alpha
        
    setRGBA: (red, green, blue, alpha = 255) ->
        @red = Math.round red
        @green = Math.round green  
        @blue = Math.round blue
        @alpha = Math.round alpha
        @draw()
        
    getRGBA: -> [@red, @green, @blue, @alpha]
    
    # Draws this pixel on the canvas
    draw: ->
        @canvas.drawPixel this
    
class TImage
    # TImage(String src)
    # TImage(int width, int height, [int[] background])
    constructor: (args...) ->
        if args.length == 1
            # grab source from Tripod
            @source = args[0]
            @image = Tripod.getImage @source
            @width = @image.width
            @height = @image.height
            @createCanvas()
            
            # draw image and load pixels that way
            @canvas.drawImage @image
            @pixels = []
            for i in [0... @size]
                x = i % @width
                y = i // @width                    
                pixel = new TPixel @canvas, x, y
                @canvas.loadPixel pixel
                @pixels.push pixel
        else
            # create from scratch
            [@width, @height, @background] = args
            @background ?= [255, 255, 255, 255]
            @createCanvas()
            
            # load in blank pixels
            @pixels = []
            for i in [0... @size]
                [r, g, b, a] = @background
                x = i % @width
                y = i // @width
                @pixels.push new TPixel @canvas, x, y, r, g, b, a            
            
    createCanvas: ->
        @size = @width * @height
        @canvas = new TCanvas @width, @height
        
    refresh: ->
        @canvas.render()
            
    getSize: -> @size
    
    getWidth: -> @width
    
    getHeight: -> @height
    
    getAllPixels: -> @pixels
    
    getPixelAt: (x, y) ->
        if 0 <= x < @width and 0 <= y < @height
            @pixels[x + y * @width]
        else
            null
            
    getCol: (x) ->
        if 0 <= x < @width
            # starting at index x, grab every @width'th pixel (width = column length)
            (pixel for pixel in @pixels[x..] by @width)
        else
            null
            
    getRow: (y) ->
        if 0 <= y < @height
            # grab @width pixels starting at row y
            start = y * @width
            @pixels[start... start + @width]
        else
            null
        
class TCanvas
    constructor: (@width, @height) ->
        @element = $('#main-canvas')
        @context = (@element.get 0).getContext "2d"
        @imageData = @context.createImageData @width, @height
        
        @element.attr width: @width, height: @height
        
    render: ->
        @context.putImageData @imageData, 0, 0
        
    # call after drawing with context to the canvas (i.e. any drawing not involving pixels)
    refreshImageData: ->
        @imageData = @context.getImageData 0, 0, @width, @height
        
    drawImage: (image) ->
        @context.drawImage image, 0, 0
        @refreshImageData()
    
    drawPixel: (pixel) ->
        index = @getIndex pixel.x, pixel.y
        @imageData.data[index + 0] = pixel.getRed()    
        @imageData.data[index + 1] = pixel.getGreen()  
        @imageData.data[index + 2] = pixel.getBlue()  
        @imageData.data[index + 3] = pixel.getAlpha()        
        # @render() # TODO inefficient to do this every single time; have user do it manually?
        
    loadPixel: (pixel) ->
        index = @getIndex pixel.x, pixel.y
        pixel.red = @imageData.data[index + 0]
        pixel.green = @imageData.data[index + 1]
        pixel.blue = @imageData.data[index + 2]
        pixel.alpha = @imageData.data[index + 3]        
        # [pixel.red, pixel.green, pixel.blue, pixel.alpha] = @imageData.data[index... index + 4]
        
    # Returns the index in @imageData that the given coordinate can be found
    getIndex: (x, y) ->
        # 4 elements (r, g, b, a) per pixel
        (x + y * @imageData.width) * 4
        
        
class _Tripod
    constructor: ->
        @sources = {}
        @images = {}
    
    # setSources(Object sourceMap)
    # setSources(String[] sourceURLs)
    setSources: (sources) ->
        if $.isArray sources
            # map URL => URL by default (nickname of source is URL) 
            @sources[url] = url for url in sources
        else
            # it's an object mapping name => URL which is just what we want
            @sources = sources
            
    getImage: (name) -> @images[name]
            
    start: (callback) ->
        # load sources
        totalSources = (key for key, value of @sources).length
        loadedSources = 0
        for name, url of @sources
            @images[name] = new Image
            @images[name].onload = () ->
                loadedSources++
                if loadedSources == totalSources
                    callback()
            @images[name].src = url
       
Tripod = new _Tripod
            
        
###
p = new TImage 100, 100
for pixel, i in p.pixels
    pixel.setRGBA 255, 0, 0, i % 100
###