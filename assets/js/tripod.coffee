###
    Tripod.js: Canvas editing like 1, 2, 3
###

class TPixel
    constructor: (@canvas, @x, @y, @red, @green, @blue, alpha = 255) ->
        @alpha = alpha

    setRed: (red) ->
        @red = Tripod.clamp red
        @draw()

    getRed: -> @red

    setGreen: (green) ->
        @green = Tripod.clamp green
        @draw()

    getGreen: -> @green

    setBlue: (blue) ->
        @blue = Tripod.clamp blue
        @draw()

    getBlue: -> @blue

    setAlpha: (alpha) ->
        @alpha = Tripod.clamp alpha
        @draw()

    getAlpha: -> @alpha

    setRGBA: (red, green, blue, alpha = 255) ->
        @red = Tripod.clamp red
        @green = Tripod.clamp green
        @blue = Tripod.clamp blue
        @alpha = Tripod.clamp alpha

        # ordinarily we'd do this but it's inefficient
        # [@red, @green, @blue, @alpha] = (clamp value for value in [red, green, blue, alpha])

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
            [@width, @height] = [@image.width, @image.height]
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

        # set this to main image if it's the first image that's been created
        Tripod.mainImage = this if Tripod.mainImage == null

    createCanvas: ->
        @size = @width * @height
        @canvas = new TCanvas @width, @height

    # Re-draws the image on the actual DOM element; call after editing the image
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

    getCols: () ->
        (@getCol(x) for x in [0... @width])

    getRows: () ->
        (@getRow(y) for y in [0... @height])

    # Draws an ellipse
    ellipse: (args...) -> @canvas.ellipse args...

    # Draws a rectangle
    rect: (args...) -> @canvas.rect args...

    # Draws text
    text: (args...) -> @canvas.text args...

    # text size
    setTextSize: (args...) -> @canvas.setTextSize args...

    getTextSize: -> @canvas.getTextSize()

    # text font family
    setTextFont: (args...) -> @canvas.setTextFont args...

    getTextFont: -> @canvas.getTextFont()

    # text horizontal alignment
    setTextAlign: (args...) -> @canvas.setTextAlign args...

    getTextAlign: -> @canvas.getTextAlign()

    # text vertical alignment
    setTextVerticalAlign: (args...) -> @canvas.setTextVerticalAlign args...

    getTextVerticalAlign: -> @canvas.getTextVerticalAlign()

    # Sets the border color for rect/ellipse calls
    setBrushColor: (args...) -> @canvas.setBrushColor args...

    getBrushColor: -> @canvas.getBrushColor()

    # Sets the fill color for rect/ellipse calls
    setBucketColor: (args...) -> @canvas.setBucketColor args...

    getBucketColor: -> @canvas.getBucketColor()

class TCanvas
    constructor: (@width, @height) ->
        @element = Tripod.canvas
        @context = (@element.get 0).getContext "2d"
        @imageData = @context.createImageData @width, @height
        @element.attr width: @width, height: @height

        # drawing and text settings
        @brushColor = [0, 0, 0, 255]
        @bucketColor = [0, 0, 0, 255]
        @textSize = 16
        @textFont = $("body").css("font-family") ? "sans-serif"
        @textAlign = "left"
        @textVerticalAlign = "bottom"

    # Updates the canvas with the current image data
    render: ->
        @context.putImageData @imageData, 0, 0

    # call after drawing with context to the canvas (i.e. any drawing not involving pixels)
    refreshImageData: ->
        @imageData = @context.getImageData 0, 0, @width, @height

    # Renders an image on the canvas
    drawImage: (image) ->
        @context.drawImage image, 0, 0
        @refreshImageData()

    # Puts data for a specific abstract pixel on the canvas's image data
    drawPixel: (pixel) ->
        index = @getIndex pixel.x, pixel.y
        @imageData.data[index + 0] = pixel.getRed()
        @imageData.data[index + 1] = pixel.getGreen()
        @imageData.data[index + 2] = pixel.getBlue()
        @imageData.data[index + 3] = pixel.getAlpha()

    # Grabs data from a specific spot in the canvas's image data and puts it in the abstract pixel
    loadPixel: (pixel) ->
        index = @getIndex pixel.x, pixel.y
        pixel.red = @imageData.data[index + 0]
        pixel.green = @imageData.data[index + 1]
        pixel.blue = @imageData.data[index + 2]
        pixel.alpha = @imageData.data[index + 3]

    # Returns the index in @imageData that the given coordinate can be found
    getIndex: (x, y) ->
        # 4 elements (r, g, b, a) per pixel
        (x + y * @imageData.width) * 4

    # After a draw function actually creates a path,
    # this handles the coloring of the path (stroke and fill), and refreshing image data.
    strokeAndFill: () ->
        @setStrokeStyle()
        @context.stroke()

        @setFillStyle()
        @context.fill()

        @refreshImageData()

    # Loads the context's stroke color with the current brush color information.
    # Call this before using @contex.fill().
    setStrokeStyle: () ->
        @context.strokeStyle = "#" + @brushColor[0].hex(2) + @brushColor[1].hex(2) + @brushColor[2].hex(2)
        @context.globalAlpha = @brushColor[3] / 255

    # Loads the context's fill color with the current bucket color information.
    # Call this before using @context.fill().
    setFillStyle: () ->
        @context.fillStyle = "#" + @bucketColor[0].hex(2) + @bucketColor[1].hex(2) + @bucketColor[2].hex(2)
        @context.globalAlpha = @bucketColor[3] / 255

    # Draws an ellipse centered at (x,y)
    # From http://stackoverflow.com/questions/2172798/how-to-draw-an-oval-in-html5-canvas
    ellipse: (x, y, width, height) ->
        x = x - width / 2.0
        y = y - height / 2.0
        w = width
        h = height

        kappa = .5522848
        ox = (w / 2) * kappa # control point offset horizontal
        oy = (h / 2) * kappa # control point offset vertical
        xe = x + w # x-end
        ye = y + h # y-end
        xm = x + w / 2 # x-middle
        ym = y + h / 2 # y-middle
        @context.beginPath()
        @context.moveTo x, ym
        @context.bezierCurveTo x, ym - oy, xm - ox, y, xm, y
        @context.bezierCurveTo xm + ox, y, xe, ym - oy, xe, ym
        @context.bezierCurveTo xe, ym + oy, xm + ox, ye, xm, ye
        @context.bezierCurveTo xm - ox, ye, x, ym + oy, x, ym

        @strokeAndFill()

    # Draws a rectangle centered at (x,y)
    rect: (x, y, width, height) ->
        @context.rect x, y, width, height

        @strokeAndFill()

    # Draws text with top left corner at (x,y)
    text: (text, x, y) ->
        # ensure font has quotes in it if it doesn't alreday
        font = if "\"" in @textFont or "\'" in @textFont then @textFont else "'#{@textFont}'"
        @context.font = "#{@textSize}px #{font}, sans-serif"
        @context.textAlign = @textAlign
        @context.textBaseline = @textVerticalAlign

        @setStrokeStyle()
        @context.strokeText text + "", x, y

        @setFillStyle()
        @context.fillText text + "", x, y

        @refreshImageData()

    # font size, in pixels, for text
    setTextSize: (size) ->
        @textSize = size

    getTextSize: -> @textSize

    # font family for text
    setTextFont: (font) ->
        @textFont = font

    getTextFont: -> @textFont

    # Horizontal alignment of text
    setTextAlign: (align) ->
        if align not in ["left", "center", "right"] then align = "left"
        @textAlign = align

    getTextAlign: -> @textAlign

    # Vertical alignment of text
    setTextVerticalAlign: (align) ->
        if align not in ["top", "middle", "bottom"] then align = "bottom"
        @textVerticalAlign = align

    getTextVerticalAlign: -> @textVerticalAlign

    # Sets the border color for rect/ellipse calls
    setBrushColor: (red, green, blue, alpha = 255) ->
        @brushColor = [ red, green, blue, alpha ]

    getBrushColor: () -> @brushColor

    # Sets the fill color for rect/ellipse calls
    setBucketColor: (red, green, blue, alpha = 255) ->
        @bucketColor = [ red, green, blue, alpha ]

    getBucketColor: () -> @bucketColor


class _Tripod
    constructor: ->
        @sources = {}
        @images = null
        @mainImage = null
        @canvas = null

    # setSources(Object sourceMap)
    # setSources(String[] sourceURLs)
    setSources: (sources) ->
        if Array.isArray sources
            # map URL => URL by default (nickname of source is URL)
            @sources[url] = url for url in sources
        else
            # it's an object mapping name => URL which is just what we want
            @sources = sources

    # Returns the image with the specified name from the sources
    getImage: (name) -> @images[name]

    # Loads images and calls the callback when ready. Call this before interacting with the image.
    start: (@canvas, callback) ->
        # reset instance vars
        @mainImage = null

        # load sources if not already loaded
        if not @images
            @images = {}
            totalSources = (key for key, value of @sources).length
            loadedSources = 0
            for name, url of @sources
                @images[name] = new Image
                @images[name].onload = () ->
                    loadedSources++
                    if loadedSources == totalSources
                        # ready to start
                        callback()
                @images[name].src = url
        else
            callback()

Tripod = new _Tripod

# utility functions

# round values and restrict to [0,255]
_Tripod::clamp = (num) ->
    num = Math.round num
    if num < 0
        return 0
    if num > 255
        return 255
    return num
