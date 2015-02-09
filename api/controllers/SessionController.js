/**
 * SessionController
 *
 * @description :: Server-side logic for managing sessions
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
  sessionInterface: function(req, res){
    Session.find(req.param('id')).populate('files').exec(function(err, sessionData){
      if(err){
        res.send('Error finding session');
      } else {
        res.view('interface', {sessionData: sessionData});
      }
    });
  }
};