const express = require('express');
const router = express.Router();

const supabase = require('../supabase');

const { checkAuthenticated, checkNotAuthenticated } = require('../passport/passportAuth');
const organizeIngredients = require('../utils/organizeIngredients') 

router.get('/', checkAuthenticated, async (req, res, next) => {
	let allRecipes = await supabase.from('recipes').select('*').eq('user_uuid', req.user.uuid).order('index', { ascending: true });
	if (allRecipes.error) {
		errorMessage = 'Database select operation failed';
		console.error(errorMessage);
		console.log(allRecipes.error);
		res.status(502).send(errorMessage);
		return;
	}

	if (allRecipes.data.length === 0) {
		res.status(204).json([]);
		return;
	}

	let organizedIngredientsArray = organizeIngredients(allRecipes.data)
	res.status(200).send(organizedIngredientsArray)
});

router.post('/', checkAuthenticated, async (req, res, next) => {
	let insertIngredients = req.body;

	const { error } = await supabase.from('recipes').insert(insertIngredients);

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
	let updatedRecipe = req.body;
	// const { error } = await supabase.rpc('update_recipe_ingredients', {
	// 	ingredients: updatedRecipe,
	// });

	const { data, error } = await supabase
	.from('recipes')
	.upsert(updatedRecipe)
	.select()

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
	let uuidToDelete = req.body.uuid; // Delete some ingredients from a recipe
	let recipeToDelete = req.body.recipe; // Delete an entire recipe

    let operationError

    if (uuidToDelete) {
		const { error } = await supabase.from('recipes').delete().in('uuid', uuidToDelete);
        operationError = error
    } else if (recipeToDelete) {
        const { error } = await supabase.from('recipes').delete().eq('card_uuid', recipeToDelete).eq('user_uuid', req.user.uuid);
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

module.exports = router;
