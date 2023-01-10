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
				// User.findOrCreate({ googleId: profile.id }, function (err, user) {
				let user = {};
				let { data, error } = await supabase.from('users').select('*').eq('google_id', profile.id);

				if (error) {
					// Error('Supabase failed to retrieving a user with matching Google id.')
					return cb(error);
				}

				if (data.length > 1) {
					//Error. Profile id should be unique.
					return cb(null, false, {message: 'Database returned more than 1 user matching a given Google id.'});
				} else if (data.length === 0) {
					// add that user
					let language = ''
					switch (profile._json.locale.slice(0, 2)) {
						case 'de':
							language = 'DE';
							break;
						case 'fr':
							language = 'FR';
							break;
						default:
							language = 'EN';
					}
					let newUser = {
						role: 'user',
						language: language,
						darkt_heme: false,
						google_id: profile.id,
						google_name: profile.displayName,
						avatar_variant: 'beam',
						avatar_colors: randomColorsArray(),
					};
					const insertUser = await supabase.from('users').insert([newUser]);

					if (insertUser.error) {
						return cb(error.message);
					}

					user = newUser;
				} else if (data.length === 1) {
					// return object containing that usert
					user = {
						role: data[0].role,
						language: data[0].language,
						darktheme: data[0].dark_theme,
						googleId: data[0].google_id,
						googleName: data[0].google_name,
						avatarVariant: data[0].avatar_variant,
						avatarColors: data[0].avatar_colors,
					};
				}
				return cb(null, user);
				// });
			}
		)
	);
};
