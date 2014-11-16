console.log "Hey from CoffeeScript"

class TPixel
    constructor: (@canvas, @x, @y, @red, @green, @blue, alpha = 255) ->
        @alpha = alpha
    
    setRed: (@red) ->
        @render()
        
    getRed: -> @red
        
    setGreen: (@green) ->
        @render()
        
    getGreen: -> @green
        
    setBlue: (@blue) ->
        @render()
        
    getBlue: -> @blue
        
    setAlpha: (@alpha) ->
        @render()
        
    getAlpha: -> @alpha
        
    setRGBA: (@red, @green, @blue, alpha = 255) ->
        @alpha = alpha
        @render()
        
    getRGBA: -> [@red, @green, @blue, @alpha]
    
    # Draws this pixel on the canvas
    render: ->
        @canvas.drawPixel this, @x, @y
    
    
class TImage
    constructor: (@width, @height, background = [ 255, 255, 255, 255 ]) ->
        @size = @width * @height
        @canvas = new TCanvas @width, @height
        @background = background
        @pixels = []
        # load in blank pixels
        for i in [0 ... @size]
            [r, g, b, a] = background
            x = i % width
            y = i // width
            @pixels.push new TPixel @canvas, x, y, r, g, b, a
            
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
            @pixels[start...start + @width]
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
    
    drawPixel: (pixel, x, y) ->
        index = @getIndex x, y
        @imageData.data[index + 0] = pixel.getRed()    
        @imageData.data[index + 1] = pixel.getGreen()  
        @imageData.data[index + 2] = pixel.getBlue()  
        @imageData.data[index + 3] = pixel.getAlpha()        
        @render() # TODO inefficient to do this every single time; have user do it manually?
        
    loadPixel: (pixel, x, y) ->
        index = @getIndex x, y
        [pixel.red, pixel.green, pixel.blue, pixel.alpha] = @imageData.data[index... index + 4]
        
    # Returns the index in @imageData that the given coordinate can be found
    getIndex: (x, y) ->
        # 4 elements (r, g, b, a) per pixel
        (x + y * @imageData.width) * 4
        
  
###
p = new TImage 100, 100
for pixel, i in p.pixels
    pixel.setRGBA 255, 0, 0, i % 100
###