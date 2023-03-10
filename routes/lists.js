const express = require('express');
const router = express.Router();

const supabase = require('../supabase');

const { body } = require('express-validator');

const { checkAuthenticated, checkNotAuthenticated } = require('../passport/passportAuth');
const organizeIngredients = require('../utils/organizeIngredients');
const { listsSchema, deleteIngredientsSchema } = require('../validateRequests/validationSchemas');
const validateRequests = require('../validateRequests/validateRequests');
const validateCSRF = require('../utils/validateCSRF');

router.get('/', checkAuthenticated, async (req, res, next) => {
	let allLists = await supabase.from('lists').select('*').eq('user_uuid', req.user.uuid).order('index', { ascending: true });
	if (allLists.error) {
		errorMessage = 'Database select operation failed';
		console.error(errorMessage);
		console.log(allLists.error);
		res.status(502).send(errorMessage);
		return;
	}

	if (allLists.data.length === 0) {
		res.status(204).send([]);
		return;
	}

	let organizedIngredientsArray = organizeIngredients(allLists.data);
	res.status(200).send(organizedIngredientsArray);
});

router.put('/', listsSchema, validateRequests, validateCSRF, checkAuthenticated, async (req, res, next) => {
	console.log('PUT /lists');
	let updatedIngredients = Array.from(req.body.ingredients);
	
	const { data, error } = await supabase.from('lists').upsert(updatedIngredients).select();

	if (error) {
		errorMessage = 'Database update operation failed';
		console.error(errorMessage);
		console.log(error);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(200).send();
});

router.put('/delete', deleteIngredientsSchema, validateRequests, validateCSRF, checkAuthenticated, async (req, res, next) => {
	let uuidToDelete = req.body.row_uuid;
	let listToDelete = req.body.card_uuid;

	let operationError;

	if (uuidToDelete) {
		if ((uuidToDelete === 'all')) {
			// Delete all ingredients before deleting user
			const { error } = await supabase.from('lists').delete().eq('user_uuid', req.user.uuid);
			operationError = error;
		} else {
			const { error } = await supabase.from('lists').delete().in('uuid', uuidToDelete).eq('user_uuid', req.user.uuid);
			operationError = error;
		}
	} else if (listToDelete) {
		const { error } = await supabase.from('lists').delete().eq('card_uuid', listToDelete).eq('user_uuid', req.user.uuid);
		operationError = error;
	}

	if (operationError) {
		errorMessage = 'Database update operation failed';
		console.error(errorMessage);
		console.log(operationError);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(200).send();
});

module.exports = router;
