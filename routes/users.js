const express = require('express');
const router = express.Router();

const supabase = require('../supabase');

const { checkAuthenticated, checkNotAuthenticated } = require('../passportAuth');

router.put('/', checkAuthenticated, async (req, res, next) => {
	let uuid = req.user.uuid;
	let columnName = req.body.columnName;
	let newValue = req.body.newValue;
	const { data, error } = await supabase
		.from('users')
		.update({ [columnName]: newValue })
		.eq('uuid', uuid);

	if (error) {
		errorMessage = new Error('Database failed to update a user.');
		console.log(errorMessage);
		console.error(error);
		res.status(502).send(errorMessage);
        return
	}

    res.status(200).send('User successfully updated')
});

router.delete('/', checkAuthenticated, async (req, res, next) => {
	let uuid = req.user.uuid;
	const { errorUser } = await supabase.from('users').delete().eq('uuid', uuid);

	if (errorUser) {
		errorMessage = new Error('Database delete operation failed');
		console.log(errorMessage);
		console.error(errorUser);
		res.status(502).send(errorMessage);
        return
	}

    const { errorAvatar } = await supabase.from('avatars').delete().eq('user_uuid', uuid);

	if (errorAvatar) {
		errorMessage = new Error('Database delete operation failed');
		console.log(errorMessage);
		console.error(errorAvatar);
		res.status(502).send(errorMessage);
        return
	}

    res.status(200).send('User successfully deleted')


});

module.exports = router;
