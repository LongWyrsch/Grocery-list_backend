const express = require('express');
const router = express.Router();

const passport = require('passport');

const { config } = require('../constants');

router.get('/', passport.authenticate('google', { scope: ['profile'] }));

router.get('/callback', passport.authenticate('google', { failureRedirect: '/signin' }), (req, res) => {
	// Successful authentication, redirect home.
	res.status(302).redirect(`${config.client_url}/home/lists`); // [1]
});

module.exports = router;

// [1] HTTP Status Code 302 is meaning you redirected from a site to an other one.
