const LocalStrategy = require('passport-local').Strategy;
const bcrypt = require('bcrypt');

const supabase = require('./supabase');

import { signupValidation, signinValidation } from './validator';

module.exports = function (passport) {
	passport.use(
		new LocalStrategy({ usernameField: 'email' }, async function (email, password, cb) {
			//Validate user input before calling database
			const validate = signinValidation({ email: email, password: password });
			if (validate.error) return cb(new Error(validate.error.details[0].message));

			//Check if can match provided email with one of our users in the database.
			let { data, error } = await supabase.from('users').select('*').eq('email', email);

			if (error) {
				// throw Error('Supabase failed to retrieving a user with matching email.');
				return cb(error);
			} else if (data.length > 1) {
				return cb(new Error('Supabase returned more than 1 user matching a given email.'));
			}

			if (data.length === 0) {
				return cb(null, false, { message: 'Supabased returned no user matching a given email' });
			}

			const user = data[0];
			try {
				if (await bcrypt.compare(password, user.hashedpassword)) {
					return cb(null, user);
				} else {
					//Email matched, but password did not match a user in our database.
					return cb(null, false, { message: 'Password incorrect' });
				}
			} catch (error) {
				return cb(error);
			}
		})
	);
};
