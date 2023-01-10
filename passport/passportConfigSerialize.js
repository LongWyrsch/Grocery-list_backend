const supabase = require('../supabase');

module.exports = function (passport) {
	passport.serializeUser((user, done) => {
		userIds = {
			uuid: user.uuid,
			google_id: user.google_id,
		};
		done(null, userIds);
	});

	passport.deserializeUser(async (userIds, done) => {
		let tempId = userIds.uuid ? userIds.uuid : userIds.google_id;
		let typeId = userIds.uuid ? 'uuid' : 'google_id';
		let { data, error } = await supabase.from('users').select('*').eq(typeId, tempId);

		if (error) {
			return done(new Error('Error when deserializing: could not find user with provided Google id.'));
		}

		let user = {
			uuid: data[0].uuid,
			email: data[0].email,
			language: data[0].language,
			dark_theme: data[0].dark_theme,
			google_name: data[0].google_name,
			avatar_variant: data[0].avatar_variant,
			avatar_colors: data[0].avatar_colors,
		};
		done(null, user);
	});
};
