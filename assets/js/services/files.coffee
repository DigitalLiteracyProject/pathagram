angular.module('pathagram')
    .service 'files', ($http) ->
        return {
            get: (callback) ->
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

                $http({
                    url: "/user/files",
                    method: "GET"
                }).success (data, status, headers, config) ->
                    console.log data
                    if data?.files?
                        for rawFile in data.files
                            file = {
                                filename: rawFile.filename,
                                contents: rawFile.source
                            }

                            files.push file

                    callback files
        }
