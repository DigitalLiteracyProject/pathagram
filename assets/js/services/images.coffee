angular.module('pathagram')
    .service 'images', () ->
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

        return images
