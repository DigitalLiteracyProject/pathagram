angular.module('pathagram')
    .service 'session', ($http) ->
        return {
            # Provides information about the current session, namely
            # *name* and *description*
            get: (callback) ->
                if window.sessionId?
                    $http({
                        url: "/session/#{window.sessionId}",
                        method: "GET",
                        responseType: "json"
                    }).success (data, status, headers, config) ->
                        console.log "Session", data
                        editedData = {
                            name: data.title,
                            description: data.details
                        }
                        callback editedData
                else
                    callback null
        }
