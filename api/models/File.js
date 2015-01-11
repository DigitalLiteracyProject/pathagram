/**
* File.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

var extension_filetypes = {
  'js': 'javascript',
  'md': 'markdown'
};

module.exports = {

  identity: 'File',

  attributes: {

    filename: {
      type: 'string',
      required: true,
    },

    source: {
      type: 'string',
      required: true,
      defaultsTo: ''
    },

    owner: {
      model: 'User'
    }
  },
};

