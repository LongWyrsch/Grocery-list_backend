// Before accessing any protected resources, make sure user is authenticated.
function checkAuthenticated(req, res, next) {
	if (req.isAuthenticated()) {
		return next();
	}
	res.status(401).send('Failed to authenticate');
}

// If user access login page, make sure he's not already authenticated. If he is, redirect him to his Lists page.
function checkNotAuthenticated(req, res, next) {
	if (req.isAuthenticated()) {
		return res.redirect('http://localhost:3001/home/lists');
	}
	next();
}

module.exports.checkAuthenticated = checkAuthenticated;
module.exports.checkNotAuthenticated = checkNotAuthenticated;
