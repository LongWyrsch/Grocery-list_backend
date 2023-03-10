const express = require('express');
const router = express.Router();

const supabase = require('../supabase');

const { checkAuthenticated, checkNotAuthenticated } = require('../passport/passportAuth');
const organizeIngredients = require('../utils/organizeIngredients');

const getKcal = require('../utils/getKcal');
const { joinRecipesSchema, recipesSchema, deleteIngredientsSchema } = require('../validateRequests/validationSchemas');
const validateRequests = require('../validateRequests/validateRequests');
const validateCSRF = require('../utils/validateCSRF');

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
		res.status(204).send([]);
		return;
	}

	let organizedIngredientsArray = organizeIngredients(allRecipes.data);
	res.status(200).send(organizedIngredientsArray);
});

router.post('/join', joinRecipesSchema, validateRequests, validateCSRF, checkAuthenticated, async (req, res, next) => {
	const selectedRecipes = req.body.selectedRecipes;
	const user_uuid = req.user.uuid;

	// const { data, error } = await supabase.rpc('test2', { recipe_uuid: ['6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'a6bf5db6-b76b-43af-a963-fab17017d731'],  useruuid: '5e08e3ee-b46e-46e4-a672-b364ed62c6a9'});
	const { data, error } = await supabase.rpc('join_ingredients', {
		recipe_uuid: selectedRecipes,
		useruuid: user_uuid,
	});
	if (error) {
		errorMessage = 'Database select operation failed';
		console.error(errorMessage);
		console.log(error);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(200).send(data);
});

// Add and modify
router.put('/', recipesSchema, validateRequests, validateCSRF, checkAuthenticated, async (req, res, next) => {
	console.log('put /recipes');
	let updatedIngredients = Array.from(req.body.ingredients);

	// Fetch kcal from USDA API before sending to database
	let promiseUpdatedCard = updatedIngredients.map(async (row) => {
		const kcal = await getKcal(row.ingredient, row.quantity, row.unit);
		return row.kcal ? row : { ...row, kcal: kcal };
	});
	updatedIngredients = await Promise.all(promiseUpdatedCard); // return await Promise.all(promiseUpdatedCard)

	// Upsert will update existing data and insert new ones. It uses the Pprimary key to match.
	const { data, error } = await supabase.from('recipes').upsert(updatedIngredients).select();

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
	let uuidToDelete = req.body.row_uuid; // Delete some ingredients from a recipe
	let recipeToDelete = req.body.card_uuid; // Delete an entire recipe

	let operationError;

	if (uuidToDelete) {
		if (uuidToDelete === 'all') {
			// Delete all ingredients before deleting user
			const { error } = await supabase.from('recipes').delete().eq('user_uuid', req.user.uuid);
			operationError = error;
		} else {
			const { error } = await supabase.from('recipes').delete().in('uuid', uuidToDelete).eq('user_uuid', req.user.uuid);
			operationError = error;
		}
	} else if (recipeToDelete) {
		const { error } = await supabase.from('recipes').delete().eq('card_uuid', recipeToDelete).eq('user_uuid', req.user.uuid);
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
