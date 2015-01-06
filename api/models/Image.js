/**
* Image.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  identity: 'Image',

  attributes: {
    filename: {
      type: 'string',
      required: true,
    },

    url: {
      type: 'string',
      required: true,
      defaultsTo: ''
    },

    owner: {
      model: 'User',
      required: true
    }
  }
};
