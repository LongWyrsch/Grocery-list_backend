const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const supabase = require('../supabase');
const { checkAuthenticated, checkNotAuthenticated } = require('../passport/passportAuth');
const { signupValidation, emailValidation, passwordValidation } = require('../utils/validator');

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
	};

	res.status(200).send(user);
});

router.get('/logout', (req, res) => {
	req.logout(function (err) {
		if (err) {
			return next(err);
		}
		res.status(200).send();
	});
});

router.put('/', checkAuthenticated, async (req, res, next) => {
	let updatedUser = req.body;

	// Convert grid layouts to JSON
	updatedUser = { ...updatedUser, layouts_recipes: JSON.stringify(updatedUser.layouts_recipes) };
	updatedUser = { ...updatedUser, layouts_lists: JSON.stringify(updatedUser.layouts_lists) };

	if (updatedUser.email !== req.user.email || 'hashed_password' in updatedUser) {
		//Validate user input before calling database
		
		
		if (updatedUser.email !== req.user.email) {
			const validate = emailValidation({ email: updatedUser.email});
			if (validate.error) return res.status(400).send(validate.error.details[0].message);

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
		
		if (updatedUser.hashed_password && updatedUser.hashed_password !== '') {
			const validate = passwordValidation({ password: updatedUser.hashed_password });
			if (validate.error) return res.status(400).send(validate.error.details[0].message);

			let hashedPassword = await bcrypt.hash(updatedUser.hashed_password, 10);
			updatedUser.hashed_password = hashedPassword
		}
	}

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

router.delete('/', checkAuthenticated, async (req, res, next) => {
	if ((req.user.role === 'admin')) {
		errorMessage = 'Cannot delete admin';
		console.error(errorMessage);
		res.status(502).send(errorMessage);
		return;
	}

	const errorUser = await supabase.from('users').delete().eq('uuid', req.user.uuid).error;

	if (errorUser) {
		errorMessage = 'Database delete operation failed';
		console.error(errorMessage);
		console.log(errorUser);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(200).send('User successfully deleted');
});

module.exports = router;
