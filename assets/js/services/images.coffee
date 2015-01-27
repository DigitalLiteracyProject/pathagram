angular.module('pathagram')
    .service 'images', ($http) ->
        return {
            get: (callback) ->
                images = [
                    {
                        path: "images/harvard-yard.jpg",
                        name: "harvard"
                    },
                    {
                        path: "images/boston.jpg",
                        name: "boston"
                    },
                    {
                        path: "images/new-york.jpg",
                        name: "new-york"
                    },
                    {
                        path: "images/fenway.jpg",
                        name: "fenway"
                    }
                ]

                $http({
                    url: "/user/images",
                    method: "GET"
                }).success (data, status, headers, config) ->
                    console.log data
                    if data?.images?
                        for rawImage in data.images
                            rawName = rawImage.imageName
                            image = {
                                path: rawImage.path
                                name: rawName.substr 0, rawName.lastIndexOf '.'
                            }

                            images.push image

                    callback images
        }
