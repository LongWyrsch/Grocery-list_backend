const express = require('express');
const router = express.Router();

const supabase = require('../supabase');

const { checkAuthenticated, checkNotAuthenticated } = require('../passportAuth');

router.get('/', checkAuthenticated, async (req, res, next) => {
	let uuid = req.user.uuid;
	let { data, error } = await supabase.from('avatars').select('*').eq('user_uuid', uuid);

	if (error) {
		errorMessage = 'Database select operation failed';
		console.error(errorMessage);
		console.log(error);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(200).send(data);
});

router.put('/', checkAuthenticated, async (req, res, next) => {
	let uuid = req.user.uuid;
	let variant = req.body.variant;
	let colors = req.body.colors;
	const { data, error } = await supabase
		.from('avatars')
		.update({ variant: variant, colors: colors })
		.eq('user_uuid', uuid);

	if (error) {
		errorMessage = 'Database update operation failed';
		console.error(errorMessage);
		console.log(error);
		res.status(502).send(errorMessage);
		return;
	}

	res.status(200).send('Avatar successfully updated');
});

module.exports = router;
