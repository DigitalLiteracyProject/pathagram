angular.module('pathagram')
    .service 'files', () ->
        files = [
            {
                filename: "yo.js",
                contents: "log('yo!');"
            },
            {
                filename: "bro.js",
                contents: "log('bro!');"
            },
            {
                filename: "go.js",
                contents: "log('go!');"
            },
        ]

        return files
