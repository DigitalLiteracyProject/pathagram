###
    Zoom addon to Tripod.js
###

class TZoom
    constructor: (@sourceCanvas, @destCanvas) ->
        @width = parseInt @sourceCanvas.attr('width')
        @height = parseInt @sourceCanvas.attr('height')

        # cache contexts for later
        @sourceContext = (@sourceCanvas.get 0).getContext '2d'
        @destContext = (@destCanvas.get 0).getContext '2d'

        # prepare destination canvas
        @destCanvas.attr 'width', @width
        @destCanvas.attr 'height', @height

        # default zoom
        @toCenter()
        @originalScale()

    zoom: ->
        # we have two canvases: source and dest
        # for each, we have a "maximal bounding box" which is the theoretical frame
        # we are drawing data from or writing data to
        # but we also have a "real bounding box" which is a clipped version of the above
        # since we can't read from outside the bounds of the original box
        # if the frame we're reading from (see getFrameWidth() and getFrameHeight())
        # is wholly inside the canvas, real == maximal
        # but if part of the frame is hanging out, real is smaller than maximal

        # we map the real source box to the real dest box
        # which essentially requires we scale the former
        # this is done in terms of "radius", which is half the width or height of a box
        # (since we need to do calculations in terms of distances from the box center)

        # for each side (top, left, bottom, right),
        # real_dest_radius = real_source_radius * @scale
        # so let's calculate the real_dest_radii

        # first preload some useful constants
        maxSourceRadiusX = @getFrameWidth() / 2
        maxSourceRadiusY = @getFrameHeight() / 2

        sourceRadii =
            top: Math.min(maxSourceRadiusY, @centerY - 0),
            left: Math.min(maxSourceRadiusX, @centerX - 0),
            bottom: Math.min(maxSourceRadiusY, @height - @centerY),
            right: Math.min(maxSourceRadiusX, @width - @centerX)

        # dest radius = @scale * source radius
        destRadii =
            top: Math.round(sourceRadii.top * @scale),
            left: Math.round(sourceRadii.left * @scale),
            bottom: Math.round(sourceRadii.bottom * @scale),
            right: Math.round(sourceRadii.right * @scale)

        # now to convert both to (x, y, width, height) where (x,y) are top left corner
        # (drawImage() needs this)
        sourceBox =
            x: @centerX - sourceRadii.left,
            y: @centerY - sourceRadii.top,
            width: sourceRadii.left + sourceRadii.right,
            height: sourceRadii.top + sourceRadii.bottom

        destCenterX = Math.round @width / 2
        destCenterY = Math.round @height / 2
        destBox =
            x: destCenterX - destRadii.left,
            y: destCenterY - destRadii.top,
            width: destRadii.left + destRadii.right,
            height: destRadii.top + destRadii.bottom

        console.log sourceBox
        console.log destBox

        @destContext.drawImage (@sourceCanvas.get 0),
            sourceBox.x,
            sourceBox.y,
            sourceBox.width,
            sourceBox.height,
            destBox.x,
            destBox.y,
            destBox.width,
            destBox.height

        # TODO this is still too sharp
        # use manual pixel manipulations here
        # https://stackoverflow.com/questions/4421914/html5-canvas-how-to-zoom-in-the-pixels

    # Position

    getWidth: -> @width

    getHeight: -> @height

    getCenterX: -> @centerX

    setCenterX: (centerX) ->
        # round and restrict to be within bounds
        @centerX = @clamp Math.round(centerX), 0, @width

    getCenterY: -> @centerY

    setCenterY: (centerY) ->
        # round and restrict to be within bounds
        @centerY = @clamp Math.round(centerY), 0, @height

    toCenter: ->
        # move to center of canvas
        @setCenterX @width / 2
        @setCenterY @height / 2

    moveCenterX: (deltaX) ->
        @setCenterX @centerX + deltaX

    moveCenterXPercent: (deltaXPercent) ->
        @moveCenterX deltaXPercent * @width / 100

    moveCenterY: (deltaY) ->
        @setCenterY @centerY + deltaY

    moveCenterYPercent: (deltaYPercent) ->
        @moveCenterY deltaYPercent * @height / 100

    # Scale

    getScale: -> @scale

    setScale: (scale) ->
        # Ensure within right range
        # For now, just zoom in is supported
        MAX_ZOOM = 20
        MIN_ZOOM = 1
        @scale = @clamp scale, MIN_ZOOM, MAX_ZOOM

    originalScale: ->
        @setScale 1

    # private

    getFrameWidth: ->
        Math.round @width / @scale

    getFrameHeight: ->
        Math.round @height / @scale

# round values and restrict to [min, max]
TZoom::clamp = (num, min, max) ->
    num = Math.round num
    if num < min
        return min
    if num > max
        return max
    return num
