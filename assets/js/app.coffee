angular.module('pathagram', []).config(
    ($compileProvider) ->
        # make angular mark data:image/png; (base64-encoded) images as safe
        $compileProvider.aHrefSanitizationWhitelist(/^\s*(data:image\/png;|http:|https:|file:)/)
)
