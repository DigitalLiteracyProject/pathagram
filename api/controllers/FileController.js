/**
 * FileController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

    // loads in a sample list of files
    init: function(req, res) {
        File.create({
            filename: "test.js",
            source: "console.log('test!');",
            owner: req.session.user.id
        }).exec(function(err, file){
            if(err) {
                console.log(err);
                res.send("Error initializing files!");
            } else {
                console.log('Created file test.js');
                res.send("Init done successfully!");
            }
        });
    },
};
