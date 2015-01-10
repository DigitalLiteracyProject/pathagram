angular.module('pathagram')
    .service 'files', () ->
        files = [
            {
                filename: "yo.js",
                contents: "console.log('yo!');"
            }
        ]

        return files
