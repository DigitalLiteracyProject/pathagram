/**
 * UserController
 *
 * @description :: Server-side logic for managing users
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var bcrypt = require('bcrypt');

module.exports = {

	login: function(req, res) {
    if(req.session.user) {
      res.redirect('dashboard');
    } else {
      res.view('login');
    }
  },

  signup: function(req, res) {
    res.view('signup');
  },

  create: function(req, res, next) {

    User.create(req.params.all()).exec(function(err, user) {
      if(err) {
        console.log('Error creating user');
        req.flash('error', 'Error creating User');
        res.redirect('/signup');
      } else {
        req.flash('success', 'New User Created');
        res.redirect('/login');
      }
    });
  },

  authenticate: function(req, res) {
    console.log(req.body);
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
    res.view('dashboard');
  }

};