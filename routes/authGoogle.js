const express = require('express');
const router = express.Router();

const passport = require('passport');

router.get('/', passport.authenticate('google', { scope: ['profile'] }));

router.get('/callback', passport.authenticate('google', { failureRedirect: '/signin' }), (req, res) => {
	// Successful authentication, redirect home.
	res.status(200).redirect('https://mygrocerylists.netlify.app/home/lists')
});

module.exports = router;
