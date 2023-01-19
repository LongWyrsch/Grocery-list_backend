const express = require('express');
const router = express.Router();

const supabase = require('../supabase');

const { checkAuthenticated, checkNotAuthenticated } = require('../passport/passportAuth');

router.get('/', checkAuthenticated, (req, res, next) => {

	let parsedLayoutsRecipes
	try {
		parsedLayoutsRecipes = JSON.parse(req.user.layouts_recipes)
	} catch (error) {
		parsedLayoutsRecipes = {}
	}
	
	let parsedLayoutsLists
	try {
		parsedLayoutsLists = JSON.parse(req.user.layouts_lists)
	} catch (error) {
		parsedLayoutsLists = {}
	}

	const user = {
		uuid: req.user.uuid,
		email: req.user.email,
		language: req.user.language,
		dark_theme: req.user.dark_theme,
		google_name: req.user.google_name,
		avatar_variant: req.user.avatar_variant,
		avatar_colors: req.user.avatar_colors,
		layouts_recipes: parsedLayoutsRecipes, 
		layouts_lists: parsedLayoutsLists
	};

	res.status(200).send(user);
});

router.get('/logout', (req, res) => {
	req.logout(function(err) {
    if (err) { return next(err); }
    res.status(200).send();
  });
});


router.put('/', checkAuthenticated, async (req, res, next) => {
	let updatedUser = req.body

	// Convert grid layouts to JSON
	updatedUser = {...updatedUser, layouts_recipes: JSON.stringify(updatedUser.layouts_recipes)} 
	updatedUser = {...updatedUser, layouts_lists: JSON.stringify(updatedUser.layouts_lists)} 

	const { data, error } = await supabase.from('users').update(updatedUser).eq('uuid', req.user.uuid);



	if (error) {
		errorMessage = new Error('Database failed to update a user.');
		console.log(errorMessage);
		console.error(error);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(200).send(req.body);
});

router.delete('/', checkAuthenticated, async (req, res, next) => {
	if ((req.user.role = 'admin')) {
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
