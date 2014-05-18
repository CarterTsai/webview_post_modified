
/*
 * GET users listing.
 */

exports.list = function(req, res){
    console.log(req);
    res.send("respond with a resource");
};

exports.signup = function(req, res){
    console.log(req);
    console.log(req.param('token'));
    console.log(req.param('email'));
    res.send("You got it");
};
