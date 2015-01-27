/**
 * ImageController
 *
 * @description :: Server-side logic for managing images
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

 var upload_path = '/assets/uploads';

module.exports = {

	upload_form: function(req, res) {
		res.view('image_upload');
	},

	upload: function(req, res) {
		console.log(req.session.user);
		req.file('image').upload({'dirname': sails.config.appPath + upload_path}, function(err, uploadedFile){
				if(err) {
					req.flash('error', 'Error uploading image');
					res.redirect('upload');
				} else {
					var filepath = uploadedFile[0].fd.split(upload_path)[1];

					Image.create({
						imageName:  uploadedFile[0].filename,
						path: '/uploads/' + filepath,
						owner: req.session.user.id
					}).exec(function(err, image){
						if(err) {
							console.log(err);
							req.flash('error', 'Error uploading image');
							res.redirect('upload');
						} else {
							req.flash('success', 'Successfully uploaded image. Go to the dashboard to view all images.');
							console.log('Uploaded image to: /uploads/' + filepath);
							res.redirect('upload');
						}

					});
				}
		});
	},

};
