const express = require('express');
const router = express.Router();

const supabase = require('../supabase');

const { checkAuthenticated, checkNotAuthenticated } = require('../passportAuth');

router.get('/', checkAuthenticated, async (req, res, next) => {
    const user = {
		email: req.user.email,
		language: req.user.language,
		darktheme: req.user.darktheme,
		googleName: req.user.googleName
	}
	res.status(200).send(user)
})

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

    res.status(200).send({ [columnName]: newValue })
});

router.delete('/', checkAuthenticated, async (req, res, next) => {
	let uuid = req.user.uuid;

    if (req.user.role  = 'admin') {
        errorMessage = 'Cannot delete admin';
		console.error(errorMessage);
		res.status(502).send(errorMessage);
        return
    }

	const errorUser  = await supabase.from('users').delete().eq('uuid', uuid).error;

	if (errorUser) {
		errorMessage = 'Database delete operation failed';
		console.error(errorMessage);
		console.log(errorUser);
		res.status(502).send(errorMessage);
        return
	}

    const errorAvatar  = await supabase.from('avatars').delete().eq('user_uuid', uuid).error;

	if (errorAvatar) {
		errorMessage = 'Database delete operation failed';
		console.error(errorMessage);
		console.log(errorAvatar);
		res.status(502).send(errorMessage);
        return
	}

    res.status(200).send('User successfully deleted')


});

module.exports = router;
