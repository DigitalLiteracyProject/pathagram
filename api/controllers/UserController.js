/**
 * UserController
 *
 * @description :: Server-side logic for managing users
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var bcrypt = require('bcrypt');
var fileController = require('./FileController');

module.exports = {

	login: function(req, res) {
    if(req.session.user) {
      res.redirect('dashboard');
    } else {
      res.view('login');
    }
  },

  signup: function(req, res) {
    if(req.session.user) {
      res.redirect('dashboard');
    } else {
      res.view('signup');
    }
  },

  create: function(req, res, next) {

    User.create(req.params.all()).exec(function(err, user) {
      if(err) {
        console.log(err);
        console.log('Error creating user');
        req.flash('error', 'Error creating User');
        res.redirect('/signup');
      } else {
		// TODO make this more secure?
		// if username == "admin", make them an admin
		if (user.username == "admin") {
			User.update({ username: user.username }, { type: "admin" }).exec(function(err, updated){
				if (err) {
					res.send("Error creating admin!");
				}
				else {
					console.log(updated[0].username + " is now admin");
				}
			});
		}

        req.flash('success', 'New user created!');

        res.redirect('login');
      }
    });
  },

  authenticate: function(req, res) {
    User.findOneByUsername(req.body.username).exec(function(err, user) {
      if(err || !user) {
        console.log('Error finding user during login');
        req.flash('error', 'Invalid username, please try again');
        res.redirect('/login');
      } else {
        bcrypt.compare(req.body.password, user.password, function(err, correct_password) {
          if(correct_password) {
            req.session.user = user;
            console.log('Authenticated user');
            res.redirect('/dashboard');
          } else {
            console.log('Invalid password');
            req.flash('error', 'Invalid Password');
            res.redirect('/login');
          }
        });
      }
    });
  },

  logout: function(req, res) {
    console.log('Logging out...');
    req.session.user = null;
    req.flash('success', 'You have been logged out!');
    res.redirect('/login');
  },

  dashboard: function(req, res){
    User.findOneById(req.session.user.id).populate('images').populate('files').populate('sessions').exec(function(err, user){
		// load dashboard
      if(err) {
        req.flash('error', 'Error finding user information!');
        res.view('dashboard');
      } else {
        Session.find({master: true}).exec(function(err, sessions){
          res.view('dashboard', {user: user.toJSON(), sessions: sessions});
        });
      }

		/*
		// load in samples if no files
		if (!user.files || user.files.length == 0) {
			fileController.createSample(req, res);
		}
		*/
    });
},

// Returns all the user's images
images: function(req, res){
	if(!req.session || !req.session.user) {
		// not logged in
		res.json(null);
	}
	else {
		User.findOneById(req.session.user.id).populate('images').exec(function(err, user){
			if(err) {
				req.flash('error', 'Error finding user information!');
				res.send('Error!');
			} else {
				res.json({ images: user.images });
			}
		});
	}
},

// Returns all the user's files
files: function(req, res){
	if(!req.session || !req.session.user) {
		// not logged in
		res.json(null);
	}
	else {
		User.findOneById(req.session.user.id).populate('files').exec(function(err, user){
			if(err) {
				req.flash('error', 'Error finding user information!');
				res.send('Error!');
			} else {
				res.json({ files: user.files });
			}
		});
	}
}

};
