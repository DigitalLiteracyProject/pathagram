angular.module('pathagram')
    .service 'files', () ->
        files = [
            {
                filename: "yo.js",
                source: "console.log('yo!');"
            }
        ]

        return files
