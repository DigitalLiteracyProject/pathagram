angular.module('pathagram')
    .service 'files', ($http) ->
        return {
            get: (callback) ->
                files = [
                    {
                        filename: "main.js",
                        contents: "var image = new TImage('harvard');\nlog('Hi from Pathagram!');\nimage.refresh();"
                    }
                ]

                $http({
                    url: "/user/files",
                    method: "GET"
                }).success (data, status, headers, config) ->
                    console.log data
                    if data?.files?
                        files = []
                        for rawFile in data.files
                            file = {
                                filename: rawFile.filename,
                                contents: rawFile.source
                            }

                            files.push file

                    callback files
            ,
            save: (file) ->
                $http({
                    url: "/file/save",
                    method: "POST",
                    data: {
                        filename: file.filename,
                        source: file.contents
                    }
                }).success (data, status, headers, config) ->
                    console.log data
        }
