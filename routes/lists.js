const express = require('express');
const router = express.Router();

const supabase = require('../supabase');

const { checkAuthenticated, checkNotAuthenticated } = require('../passportAuth');

router.get('/', checkAuthenticated, async (req, res, next) => {
	const distinctLists = await supabase.rpc('select_distinct', { querycolumn: 'list', useruuid: req.user.uuid });
	if (distinctLists.error) {
		errorMessage = 'Database select operation failed';
		console.error(errorMessage);
		console.log(distinctLists.error);
		res.status(502).send(errorMessage);
		return;
	}

	let allLists = await supabase.from('lists').select('*').eq('user_uuid', req.user.uuid);
	if (allLists.error) {
		errorMessage = 'Database select operation failed';
		console.error(errorMessage);
		console.log(allLists.error);
		res.status(502).send(errorMessage);
		return;
	}

	if (allLists.data.length === 0) {
		res.status(204).json([]);
		return;
	}

	res.status(200).json({
		distinctLists: distinctLists.data,
		allListIngredients: allLists.data,
	});
});

router.post('/', checkAuthenticated, async (req, res, next) => {
	let insertIngredients = req.body;
	const { error } = await supabase.from('lists').insert(insertIngredients);

	if (error) {
		errorMessage = 'Database insert operation failed';
		console.error(errorMessage);
		console.log(error);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(201);
});

router.put('/', checkAuthenticated, async (req, res, next) => {
	let updatedIngredients = req.body;
	const { error } = await supabase.rpc('update_list_ingredients', {
		ingredients: updatedIngredients,
	});

	if (error) {
		errorMessage = 'Database update operation failed';
		console.error(errorMessage);
		console.log(error);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(200);
});

router.delete('/', checkAuthenticated, async (req, res, next) => {
	let uuidToDelete = req.query.uuid;
	let listToDelete = req.query.list;

    let operationError

    if (uuidToDelete) {
	    const { error } = await supabase.from('lists').delete().in('uuid', uuidToDelete);
        operationError = error
    } else if (listToDelete) {
        const { error } = await supabase.from('lists').delete().eq('title', listToDelete).eq('user_uuid', req.user.uuid);
        operationError = error
    }

	if (operationError) {
		errorMessage = 'Database update operation failed';
		console.error(errorMessage);
		console.log(operationError);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(200);
});
