var GoogleStrategy = require('passport-google-oauth20').Strategy;
const supabase = require('../supabase');
const randomColorsArray = require('../utils/randomColorsArray');

module.exports = function (passport) {
	passport.use(
		new GoogleStrategy(
			{
				clientID: process.env.GOOGLE_CLIENT_ID,
				clientSecret: process.env.GOOGLE_CLIENT_SECRET,
				callbackURL: '/auth/google/callback',
			},
			async function (accessToken, refreshToken, profile, cb) {
				let user = {};
				let { data, error } = await supabase.from('users').select('*').eq('google_id', profile.id);

				if (error) {
					// Error('Supabase failed to retrieving a user with matching Google id.')
					return cb(error);
				}

				if (data.length > 1) {
					//Error. Profile id should be unique.
					return cb(null, false, {
						message: 'Database returned more than 1 user matching a given Google id.',
					});
				} else if (data.length === 0) {
					// add that user
					let language = profile._json.locale.slice(0, 2)
					
					let newUser = {
						role: 'user',
						language: language,
						theme: 'light',
						google_id: profile.id,
						google_name: profile.displayName,
						avatar_variant: 'beam',
						avatar_colors: randomColorsArray(),
						layouts_recipes: {},
						layouts_lists: {}
					};
					const insertUser = await supabase.from('users').insert([newUser]);

					if (insertUser.error) {
						return cb(insertUser.error.message);
					}

					user = newUser;
				} else if (data.length === 1) {
					// return object containing that usert
					user = {
						role: data[0].role,
						language: data[0].language,
						theme: data[0].theme,
						google_id: data[0].google_id,
						google_name: data[0].google_name,
						avatar_variant: data[0].avatar_variant,
						avatar_colors: data[0].avatar_colors,
						layouts_recipes: data[0].layouts_recipes,
						layouts_lists: data[0].layouts_lists,
					};
				}
				return cb(null, user);
				// });
			}
		)
	);
};
