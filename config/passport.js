var passport = require('passport');

LocalStrategy = require('passport-local').Strategy;

module.exports = {
    http: {
        customMiddleware: function(app) {
            console.log('Loading Express middleware for Passport.js');
            app.use(passport.initialize());
            app.use(passport.session());
        }
    }
}