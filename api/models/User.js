/**
* User.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

var bcrypt = require('bcrypt');

module.exports = {

  identity: 'User',

  attributes: {
    username: {
      type: 'string',
      required: true,
      unique: true
    },

    password: {
      type: 'string',
      required: true
    },

    files: {
      collection: 'Image',
      via: 'owner',
      required: true,
      defaultsTo: []
    },

    images: {
      collection: 'Image',
      via: 'owner',
      required: true,
      defaultsTo: []
    },

    toJSON: function() {
      var obj = this.toObject();
      delete obj.password;
      return obj;
    },

  },

  beforeCreate: function(user, next) {
    bcrypt.genSalt(10, function(err, salt) {
      bcrypt.hash(user.password, salt, function(err, hash) {
        if(err){
          console.log(err);
          next(err);
        } else {
          user.password = hash;
          next(null, user);
        }
      });
    });
  },


};

