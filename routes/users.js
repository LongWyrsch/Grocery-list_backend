const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const supabase = require('../supabase');
const { checkAuthenticated, checkNotAuthenticated } = require('../passport/passportAuth');
const { updateUserSchema } = require('../validateRequests/validationSchemas');
const validateRequests = require('../validateRequests/validateRequests');
const { v4: uuidv4 } = require('uuid');
const validateCSRF = require('../utils/validateCSRF');

router.get('/', checkAuthenticated, (req, res, next) => {
	let parsedLayoutsRecipes;
	try {
		parsedLayoutsRecipes = JSON.parse(req.user.layouts_recipes);
	} catch (error) {
		parsedLayoutsRecipes = {};
	}

	let parsedLayoutsLists;
	try {
		parsedLayoutsLists = JSON.parse(req.user.layouts_lists);
	} catch (error) {
		parsedLayoutsLists = {};
	}

	req.session.CSRF_token = uuidv4();

	const user = {
		uuid: req.user.uuid,
		email: req.user.email,
		language: req.user.language,
		theme: req.user.theme,
		google_name: req.user.google_name,
		avatar_variant: req.user.avatar_variant,
		avatar_colors: req.user.avatar_colors,
		layouts_recipes: parsedLayoutsRecipes,
		layouts_lists: parsedLayoutsLists,
		CSRF_token: req.session.CSRF_token,
	};

	res.status(200).send(user);
});

router.get('/signout', checkAuthenticated, (req, res) => {
	req.logout(function (err) {
		if (err) {
			return next(err);
		}
		res.status(200).send();
	});
});

router.put('/', updateUserSchema, validateRequests, validateCSRF, checkAuthenticated, async (req, res, next) => {
	let updatedUser = req.body.updatedUser;

	console.log('put /users req.body: ', req.body)
	console.log('put /users req.body.updatedUser: ', req.body.updatedUser)

	// Convert grid layouts to JSON
	updatedUser = { ...updatedUser, layouts_recipes: JSON.stringify(updatedUser.layouts_recipes) };
	updatedUser = { ...updatedUser, layouts_lists: JSON.stringify(updatedUser.layouts_lists) };

	// If user tried to change his email, validate it
	if (updatedUser.email !== req.user.email) {
		let { data, error } = await supabase.from('users').select('*').eq('email', updatedUser.email);
		let errorMessage = '';

		if (error) {
			errorMessage = new Error('Supabase failed to retrieving a user with matching email.');
			console.log(errorMessage);
			console.error(error);
			res.status(502).send(errorMessage);
			return;
		} else if (data.length > 1) {
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
		}
	}

	// If user tried to change his password, validate it.
	if ('hashed_password' in updatedUser && updatedUser.hashed_password !== '') {
		let hashedPassword = await bcrypt.hash(updatedUser.password, 10);
		updatedUser.hashed_password = hashedPassword;
	}

	// Database doesn't store CSRF tokens.
	delete updatedUser.CSRF_token

	const { data, error } = await supabase.from('users').update(updatedUser).eq('uuid', req.user.uuid);

	if (error) {
		errorMessage = new Error('Database failed to update a user.');
		console.log(errorMessage);
		console.error(error);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(200).send();
});

router.delete('/', checkAuthenticated, validateCSRF, async (req, res, next) => {
	if (req.user.role === 'admin') {
		errorMessage = 'Cannot delete admin';
		console.error(errorMessage);
		res.status(403).send(errorMessage);
		return;
	}

	const errorUser = await supabase.from('users').delete().eq('uuid', req.user.uuid);

	if (errorUser.error) {
		errorMessage = 'Database delete operation failed';
		console.error(errorMessage);
		console.log(errorUser.error);
		res.status(502).send(errorMessage);
		return;
	}

	req.logout(function (err) {
		if (err) {
			return next(err);
		}
		res.status(200).send();
	});
});

module.exports = router;
