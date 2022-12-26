const express = require('express');
const router = express.Router();

const bcrypt = require('bcrypt')

const passport = require('passport');

const supabase = require('../supabase');

var cors = require('cors');
var corsOptions = {
	origin: 'http://localhost:3001',
	optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
};

router.post(
	'/login',
	cors(corsOptions),
	passport.authenticate('local', { failureRedirect: 'http://localhost:3001/loginlocal' }),
	(req, res) => {
		res.status(201).json({
			msg: 'New user created!',
			user,
		})
	}
);

router.post('/register', cors(corsOptions), async (req, res) => {
	const { email, password } = req.body;

	let { data, error } = await supabase.from('users').select('*').eq('email', email);

	if (error) {
		throw Error('Supabase failed to retrieving a user with matching email.');
	}

	if (data.length > 1) {
		//Error. Profile id should be unique.
		throw Error('Supabase returned more than 1 user matching a given email.');
	} else if (data.length === 1) {
		res.send('User with that email already exists.')
        return
	} else if (data.length === 0) {
		// add that user
		let language = 'ENG'
        let hashedPassword = await bcrypt.hash(password, 10);
		const { dataInserted, errorInserted } = await supabase.from('users').insert([
			{
				email: email,
                hashedpassword: hashedPassword,
                role: 'user',
				language: language,
				darkmode: false
			},
		]);

		if (errorInserted) {
			throw Error(errorInserted);
		}

		res.status(201).json({
			msg: 'New user created!',
			user: {email: email},
		})
	}

	
});

module.exports = router;
