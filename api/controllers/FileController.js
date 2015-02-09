/**
 * FileController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
    /*
    // loads in a sample list of files
    createSample: function(req, res) {
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
    */

    // updates the model's (given by name) source
    // specify filename, source
    save: function (req, res) {
        if (req.session.user) {
            if (req.body && req.body.filename && req.body.source) {
                var filename = req.body.filename;

                File.findOne({
                    filename: filename,
                    owner: req.session.user.id
                }).exec(function(err, file){
                    if(err) {
                        res.send('Error! Query was:');
                        res.send(JSON.parse(req.body));
                    }
                    else if(!file) {
                        // not found; fail
                        res.send('File ' + filename + ' not found!');
                    }
                    else {
                        file.source = req.body.source;
                        file.save();
                        res.send('Saved ' + filename + '!');
                    }
                });
            }
            else {
                res.send('Bad query!');
            }
        }
        else {
            res.send('Not logged in!');
        }
    }
};
