const LocalStrategy = require('passport-local').Strategy;
const bcrypt = require('bcrypt');

const supabase = require('../supabase');

module.exports = function (passport) {
	passport.use(
		new LocalStrategy({ usernameField: 'email' }, async function (email, password, done) {
			
			//Check if can match provided email with one of our users in the database.
			let { data, error } = await supabase.from('users').select('*').eq('email', email);
			
			if (error) {
				// throw Error('Supabase failed to retrieving a user with matching email.');
				return done(error);
			} else if (data.length > 1) {
				return done(null, false, {message: 'Database returned more than 1 user matching a given email.'});
			}
			
			if (data.length === 0) {
				return done(null, false, { message: 'Database returned no user matching a given email' });
			}
			
			const user = data[0];
			try {
				if (await bcrypt.compare(password, user.hashed_password)) {
					return done(null, user);
				} else {
					//Email matched, but password did not match a user in our database.
					return done(null, false, { message: 'Password incorrect' });
				}
			} catch (error) {
				return done(error);
			}
		})
	);
};
