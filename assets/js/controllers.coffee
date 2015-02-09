angular.module('pathagram')
    .controller 'MainCtrl', ($scope, $http, files, images, session) ->
        # init scope
        $scope.ran = no # turns yes once code is run
        $scope.success = no # yes if the code worked
        $scope.error = null # any errors running the code are shown here
        $scope.logs = [] # log entries
        $scope.showEdited = yes # whether to show the edited version of the image
        $scope.canvasReady = no # whether the edited image has shown up on the canvas
        $scope.tabs = [] # active tabs
        $scope.activeTab = 0 # the default active tab is the first file

        # if we're working in a session (lesson), interface may look different
        $scope.inSession = window.sessionId?
        $scope.session = null
        # grab information about session
        if $scope.inSession
            session.get (sessionInfo) ->
                $scope.session = sessionInfo

        # load snippets
        $scope.snippets = [
            "Original",
            "Brightness",
            "Contrast",
            "Saturation",
            "Grayscale",
            "Black and White",
            "Sepia",
            "Posterize",
            "Blur",
            "Sharpen",
            "Darken Edges",
            "Add Noise",
            "Superhero",
            "Meme",
            "Snapchat",
            # "Fire and Sky"
        ]

        # Loads a sample text snippet, puts it in the editor, and executes it.
        $scope.loadSnippet = (snippet) ->
            name = snippet.toLowerCase().replace(/\ /g, "-")

            $http.get("snippets/#{name}.js").success (data) ->
                editor.setValue data
                $scope.runInput()

        # Loads in (but doesn't run) a file from the files service.
        $scope.loadFile = (file) ->
            if file not in $scope.tabs
                $scope.tabs.push file
                $scope.changeActiveTab $scope.tabs.length - 1
            else
                $scope.changeActiveTab $scope.tabs.indexOf file

        # Change the active tab
        $scope.changeActiveTab = (index) ->
            $scope.activeTab = index
            editor.setValue $scope.tabs[index].contents

        $scope.showTabCloseButton = -> $scope.tabs.length > 1

        # Closes tab at given index and, if it's active,
        # loads the right tab (if one exists), else the left tab (this is how browsers do it)
        $scope.closeTab = (index) ->
            $scope.tabs = _.without $scope.tabs, $scope.tabs[index]
            if index == $scope.activeTab
                numTabs = $scope.tabs.length
                if index == numTabs
                    # was the last one; load the new last one (what used to be to the left)
                    $scope.changeActiveTab numTabs - 1
                else
                    # was in the middle; load the new one at that place (what used to be to the right)
                    $scope.changeActiveTab index

        # Saves the active tab back to the server
        $scope.saveActiveTab = () ->
            currentFile = $scope.tabs[$scope.activeTab]
            currentFile.contents = editor.getValue()
            files.save currentFile

        # Runs the code inside the editing box
        $scope.runInput = () ->
            # reset anything that should reset after each run
            $scope.logs = []

            # wrap it in a function so they just write the body of the function
            Tripod.start $('#main-canvas'), () ->
                code = editor.getValue()
                try
                    $scope.ran = yes
                    $scope.canvasReady = no

                    eval code

                    # it worked
                    $scope.success = yes
                    $scope.canvasReady = yes

                    # do other success-based stuff later; if it throws error, we don't want it showing up here
                    # since that'd make user think they made an error
                catch error
                    console.log window.E = error

                    $scope.success = no
                    $scope.error = error
                finally
                    # other things to do in case of success
                    if $scope.success
                        $scope.viewEdited()

                        # prepare zoomer
                        $scope.initZoom()

                    # you can only have $scope.$apply once in a call stack, so defer it
                    _.defer () -> $scope.$apply()

        # show edited or original version of image
        $scope.viewOriginal = -> $scope.showEdited = no
        $scope.viewEdited = -> $scope.showEdited = yes

        # static original image to show on top of edited one
        $scope.getCanvasWidth = -> $('#main-canvas').attr 'width'
        $scope.getCanvasHeight = -> $('#main-canvas').attr 'height'
        $scope.getFilename = -> Tripod.mainImage?.image?.src

        # to download the image
        $scope.getImageDataUrl = -> $('#main-canvas').get(0).toDataURL()

        # Prints debug information about an object
        $scope.log = (object) ->
            # coerce to a string so that toString() is called
            $scope.logs.push object + ""

        window.log = $scope.log

        # zoom
        $scope.zoomer = null # handles zoom operations of the original image
        $scope.validZoomScales = []

        # resets the zoomer with the contents of the canvas, and prepares events on its companion image
        # re-run whenever new image is drawn on canvas
        $scope.initZoom = () ->
            $scope.zoomer = new TZoom $('#main-canvas'), $('#zoom-canvas')

            # companion image, when clicked, will move the zoom center to the click location, then zoom
            companionImage = $ '#zoom-image'
            companionImage.unbind('click').bind 'click', (event) =>
                $element  = $(event.target)

                # get raw coordinates (where top left is 0,0)
                offset = $element.offset()
                relativeX = event.pageX - offset.left
                relativeY = event.pageY - offset.top

                # we can't go directly from raw coordinates to canvas coordinates
                # since, if image is shrunk by browser, raw coordinates will be smaller than canvas coordinates
                # since the image itself will be smaller
                # so instead use a ratio: canvasX / canvasWidth = rawX / rawY

                # convert to canvas coordinates
                canvasWidth = $scope.zoomer.getWidth()
                canvasHeight = $scope.zoomer.getHeight()
                canvasX = Math.round canvasWidth * relativeX / $element.width()
                canvasY = Math.round canvasHeight *relativeY / $element.height()

                # now move the zoom canvas's center to that point and zoom
                $scope.setZoomCenterX canvasX
                $scope.setZoomCenterY canvasY
                $scope.runZoom()

            # set valid zoom scales based on image size
            proposedZoomScales = [1, 2, 5, 10, 25, 50, 100, 250, 500, 1000]
            # only use scales where min <= scale <= max
            # TZoom lets us zoom in as far as possible (so that only 1 pixel shows up)
            # but that's way too far for our use; restrict the max scale
            maxZoomScale = $scope.zoomer.getMaxScale() / 5
            minZoomScale = $scope.zoomer.getMinScale()
            $scope.validZoomScales = _.filter proposedZoomScales, (scale) ->
                minZoomScale <= scale <= maxZoomScale

        $scope.showZoomModal = () ->
            $('#zoom-modal').modal 'show'
            # just so we have something to show...
            @runZoom()

        # loads the zoom canvas with the zoomed contents of the actual canvas
        $scope.runZoom = () ->
            return if not $scope.zoomer?
            $scope.zoomer.zoom()
        $scope.setZoomCenterX = (x) ->
            $scope.zoomer.setCenterX x
        $scope.setZoomCenterY = (y) ->
            $scope.zoomer.setCenterY y
        $scope.setZoomScale = (scale) ->
            $scope.zoomer.setScale scale
        $scope.getZoomScale = ->
            if $scope.zoomer? then $scope.zoomer.getScale() else 1

        # ace editor
        editor = ace.edit "editor"
        editor.setTheme "ace/theme/xcode"
        editor.getSession().setUseWrapMode true
        editor.getSession().setMode "ace/mode/javascript"

        # save on change
        editor.on 'change', _.throttle $scope.saveActiveTab, 5000

        # instantiate ace EditSession for tabs
        editSession = ace.require("ace/edit_session").EditSession

        # load up files
        files.get (fileList) ->
            $scope.files = fileList
            $scope.loadFile $scope.files[0]

        # load up images
        # init tripod by preparing the images it uses
        # we need to go up a level since files given to us are relative to /assets
        # but we're in the /js folder, which is a child of that
        # APPEND_TO_FILE_PATH = "../"
        images.get (imageList) ->
            $scope.images = imageList
            sources = {}
            _.each $scope.images, (image) ->
                sources[image.name] = image.path
            Tripod.setSources sources
