angular.module('pathagram', [])
    .controller 'MainCtrl', ($scope, $http, files) ->
        # render ace editor
        editor = ace.edit "editor"
        editor.setTheme "ace/theme/xcode"
        editor.getSession().setUseWrapMode true
        editor.getSession().setMode "ace/mode/javascript"

        # init tripod
        Tripod.setSources {
            "new-york": "../images/new-york.jpg",
            "boston": "../images/boston.jpg",
            "harvard": "../images/harvard-yard.jpg"
            }

        # files
        $scope.files = files

        # init scope
        $scope.ran = no # turns yes once code is run
        $scope.success = no # yes if the code worked
        $scope.error = null # any errors running the code are shown here
        $scope.logs = [] # log entries
        $scope.showEdited = yes # whether to show the edited version of the image
        $scope.canvasReady = no # whether the edited image has shown up on the canvas

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
            "Fire and Sky"
        ]

        # Loads a sample text snippet, puts it in the editor, and executes it.
        $scope.loadSnippet = (snippet) ->
            console.log snippet
            name = snippet.toLowerCase().replace(/\ /g, "-")

            $http.get("snippets/#{name}.js").success (data) ->
                editor.setValue data
                $scope.runInput()

        # Loads in (but doesn't run) a file from the files service.
        $scope.loadFile = (file) ->
            editor.setValue file.source

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
                    $scope.viewEdited()
                catch error
                    console.log window.E = error

                    $scope.success = no
                    $scope.error = error
                finally
                    # $('#loading-modal').modal 'hide'
                    # $('#run').button 'reset'

                    # you can only have $scope.$apply once in a call stack, so defer it
                    _.defer () -> $scope.$apply()

        # show edited or original version of image
        $scope.viewOriginal = -> $scope.showEdited = no
        $scope.viewEdited = -> $scope.showEdited = yes

        # static original image to show on top of edited one
        $scope.getCanvasWidth = -> $('#main-canvas').attr 'width'
        $scope.getCanvasHeight = -> $('#main-canvas').attr 'height'
        $scope.getFilename = -> Tripod.mainImage?.image?.src

        # Prints debug information about an object
        $scope.log = (object) ->
            # coerce to a string so that toString() is called
            $scope.logs.push object + ""

        window.log = $scope.log

        # last bit of init
        $scope.loadSnippet "original"
