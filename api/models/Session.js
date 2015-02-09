/**
* Session.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  identity: 'Session',

  attributes: {

    title: {
      type: 'string',
      required: true,
      defaultsTo: 'Untitled'
    },

    details: {
      type: 'string',
      required: false
    },

    files: {
      collection: 'File',
      defaultsTo: []
    },

    reference: {
      model: 'Session'
    },

    master: {
      type: 'boolean',
      required: true
    },

    owner: {
      model: 'User'
    }

  },
};
