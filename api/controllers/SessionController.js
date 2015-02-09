/**
 * SessionController
 *
 * @description :: Server-side logic for managing sessions
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

    // Creates a new master session. Only for admin users.
    createMaster: function(req, res){
        if (req.session.user.type == "admin"){
            // Required: title, details, filenames

            // first create files with the specified names
            var fileObjects = _.map(filenames, function(filename){
                return {
                    filename: filename,
                    source: "",
                    owner: req.session.user.id
                }
            });

            console.log(fileObjects);

            File.create(fileObjects).exec(function(err, files){
                if (err) {
                    res.send("Error creating files!");
                }
                else {
                    console.log(req.param('title'));
                    Session.create({
                        title: req.param('title'),
                        details: req.param('details'),
                        files: fileArray,
                        master: true,
                        user: req.session.user.id
                    });

                    res.redirect('dashboard');
                }
            });
        }
        else {
            res.send('Error: only admins can create master sessions!');
        }
    },

  sessionInterface: function(req, res){
    // If the user is an admin, display the session no matter what
    if(req.session.user.type == 'admin'){
      Session.find(req.param('id')).populate('files').exec(function(err, sessionData){
        if(err){
          res.send('Error finding session');
        } else {
          res.view('interface', {sessionData: sessionData});
        }
      });
    } else {
      // if the user is not an admin...
      // check if the session is a master, if it is, look for the appropriate user instance
      Session.find(req.param('id')).exec(function(err, sessionData){
        if(err){
          res.send('Error finding session');
        } else {
          if(sessionData.master == true){
            // find the user's version(s) of this
            Session.find({master: false, owner: req.session.user.id, reference: req.param('id')}).exec(function(err, data){
              if(err){
                res.send('Error finding session');
              } else if(data) {
                res.view('interface', {sessionData: data});
              } else {
                // make a new user instance
                newObjectData = {title: sessionData.title, details: sessionData.details, files: sessionData.files, master: false, reference: sessionData.id, owner: req.session.user.id};
                Session.create(newObjectData).exec(function(req, res, createdObject){
                  if(err){
                    res.send('Error making new session');
                  } else {
                    res.view('interface', {sessionData: createdObject});
                  }
                });
              }
            });
          }
        }
      });
    }
  }
};
