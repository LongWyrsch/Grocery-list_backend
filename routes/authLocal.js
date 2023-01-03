const express = require('express');
const router = express.Router();

const bcrypt = require('bcrypt')

const passport = require('passport');

const supabase = require('../supabase');

// I temp commented this section. I moved the cors option middleware the app.js so I don't have to add it in every .js routes.
// var cors = require('cors');
// var corsOptions = {
// 	origin: 'http://localhost:3001',
// 	optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
// };

router.post('/signin', passport.authenticate('local', { failureRedirect: 'http://localhost:3001/signin' }), (req, res) => {
	res.status(200).json({
		msg: 'Login successful',
		user: req.user,
	})
});

router.post('/signup', async (req, res) => {
	const { email, password } = req.body;

	let { data, error } = await supabase.from('users').select('*').eq('email', email);
	let errorMessage = ''

	if (error) {
		errorMessage = new Error('Supabase failed to retrieving a user with matching email.')
		console.log(errorMessage)
		console.error(error)
		res.status(502).send(errorMessage)
		return
	}

	if (data.length > 1) {
		//Error. Profile id should be unique.
		errorMessage = 'Supabase returned more than 1 user matching a given email.'
		console.log(errorMessage)
		res.status(500).send(errorMessage)
		return
	} else if (data.length === 1) {
		errorMessage = 'User with that email already exists.'
		console.log(errorMessage)
		res.status(400).send(errorMessage)
        return
	} else if (data.length === 0) {
		// add that user
		let language = 'ENG'
        let hashedPassword = await bcrypt.hash(password, 10);
		let newUser = {
			email: email,
			hashedpassword: hashedPassword,
			role: 'user',
			language: language,
			darkmode: false
		}
		const { dataInserted, errorInserted } = await supabase.from('users').insert([newUser]);

		if (errorInserted) {
			errorMessage = 'Database failed to create new user.'
			console.log(errorInserted)
			res.status(502).send(errorMessage)
			return
		}

		res.status(201).json({
			msg: 'New user created!',
			user: newUser,
		})
	}

	
});

module.exports = router;
