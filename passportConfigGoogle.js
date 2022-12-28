var GoogleStrategy = require('passport-google-oauth20').Strategy;
const supabase = require('./supabase');

module.exports = function (passport) {
  passport.use(
		new GoogleStrategy(
			{
				clientID: process.env.GOOGLE_CLIENT_ID,
				clientSecret: process.env.GOOGLE_CLIENT_SECRET,
				callbackURL: '/auth/google/callback',
			},
			async function (accessToken, refreshToken, profile, cb) {
				// User.findOrCreate({ googleId: profile.id }, function (err, user) {
				let user = {};
				let { data, errorFindUser } = await supabase.from('users').select('*').eq('googleId', profile.id);

				if (errorFindUser) {
					// Error('Supabase failed to retrieving a user with matching Google id.')
					return cb(errorFindUser)
				}

				if (data.length > 1) {
					//Error. Profile id should be unique.
					return cb(new Error('Supabase returned more than 1 user matching a given Google id.'))
				} else if (data.length === 0) {
					// add that user
					let language = profile._json.locale.slice(0, 2) === 'en' ? 'ENG' : 'DEU';
					const { data, errorInsertUser } = await supabase.from('users').insert([
						{
							role: 'user',
							language: language,
							darkmode: false,
							googleId: profile.id,
							googleName: profile.displayName,
						},
					]);

					if (errorInsertUser) {
						return cb(errorInsertUser);
					}

					user = {
						role: 'user',
						language: language,
						darkmode: false,
						googleId: profile.id,
						googleName: profile.displayName,
					};
				} else if (data.length === 1) {
					// return object containing that usert
					user = {
						role: data[0].role,
						language: data[0].language,
						darkmode: data[0].darkmode,
						googleId: data[0].googleId,
						googleName: data[0].googleName,
					};
				}

				return cb(null, user);
				// });
			}
		)
	);
};
