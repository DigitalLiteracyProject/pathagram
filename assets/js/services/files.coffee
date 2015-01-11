angular.module('pathagram')
    .service 'files', () ->
        files = [
            {
                filename: "yo.js",
                contents: "console.log('yo!');"
            },
            {
                filename: "bro.js",
                contents: "console.log('bro!');"
            }
        ]

        return files
