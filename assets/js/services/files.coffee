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
                    url: "/session/1/files",
                    method: "GET",
                    responseType: "json"
                }).success (data, status, headers, config) ->
                    console.log data
                    # each element of data is a file
                    files = _.map data, (rawFile) ->
                        {
                            filename: rawFile.filename,
                            contents: rawFile.source,
                            id: rawFile.id
                        }

                    callback files
            ,
            save: (file) ->
                $http({
                    url: "/file/save",
                    method: "POST",
                    data: {
                        id: file.id
                        source: file.contents
                    }
                }).success (data, status, headers, config) ->
                    console.log data
        }
