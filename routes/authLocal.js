const express = require('express');
const router = express.Router();

const bcrypt = require('bcrypt');

const passport = require('passport');

const supabase = require('../supabase');

const randomColorArray = require('../utils/randomColorsArray');

const { signupValidation, signinValidation } = require('../utils/validator');

// I temp commented this section. I moved the cors option middleware the app.js so I don't have to add it in every .js routes.
// var cors = require('cors');
// var corsOptions = {
// 	origin: 'http://localhost:3001',
// 	optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
// };

// I was confused by the (req,res,next) appended at the end of passport.authenticate(...).
// passport.authenticate(...) is a function returning a middleware. Like all middleware, you must pass it req,res and next.
// Without next, it cannot call the next middleware in the stack.
router.post('/signin', (req, res, next) => {
	passport.authenticate('local', (err, user, options) => {
		if (err) return next(err); // will generate a 500 error

		if (typeof options !== 'undefined') {
			// Can also generate a JSON response reflecting authentication status
			console.log(res.locals.errMessage);
			return res.status(403).send();
		}
		
		// The app uses a custom callback so that it can access the error messages. Therfore, the login() function must be manually implemented.
		req.login(user, (loginErr) => {
			if (loginErr) {
				return next(loginErr);
			}
			return res.status(200).send();
		});
	})(req, res, next);  // <<== appended (req,res,next). Explanation above.
});

router.post('/signup', async (req, res) => {
	const { email, password, darktheme, language } = req.body;

	//Validate user input before calling database
	const validate = signupValidation({email: req.body.email, password: req.body.password});
	if (validate.error) return res.status(400).send(validate.error.details[0].message);

	let { data, error } = await supabase.from('users').select('*').eq('email', email);
	let errorMessage = '';

	if (error) {
		errorMessage = new Error('Supabase failed to retrieving a user with matching email.');
		console.log(errorMessage);
		console.error(error);
		res.status(502).send(errorMessage);
		return;
	}

	if (data.length > 1) {
		//Error. Profile id should be unique.
		errorMessage = 'Supabase returned more than 1 user matching a given email.';
		console.log(errorMessage);
		res.status(500).send(errorMessage);
		return;
	} else if (data.length === 1) {
		errorMessage = 'User with that email already exists.';
		console.log(errorMessage);
		res.status(403).send(errorMessage);
		return;
	} else if (data.length === 0) {
		// add that user
		let hashedPassword = await bcrypt.hash(password, 10);
		let newUser = {
			email: email,
			hashedpassword: hashedPassword,
			role: 'user',
			language: language,
			darktheme: darktheme,
			avatarVariant: 'beam',
			avatarColors: randomColorArray(),
		};
		const insertUser = await supabase.from('users').insert([newUser]);

		if (insertUser.error) {
			errorMessage = 'Database failed to create new user.';
			console.log(insertUser.error);
			res.status(502).send(errorMessage);
			return;
		}

		res.status(201).send();
		// res.status(201).json({
		// 	msg: 'New user created!',
		// 	user: {
		// 		email: newUser.email,
		// 		language: newUser.language,
		// 		darktheme: newUser.darktheme,
		// 		googleName: '',
		// 	}
		// });
	}
});

module.exports = router;
