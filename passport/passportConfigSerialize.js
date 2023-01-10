const supabase = require('../supabase');

module.exports = function (passport) {
  passport.serializeUser((user, done) => {
    userIds = {
      uuid: user.uuid,
      googleId: user.googleId
    }
    done(null, userIds);
  });

  passport.deserializeUser(async(userIds, done) => {
    let tempId = userIds.uuid ? userIds.uuid : userIds.googleId
    let typeId = userIds.uuid ? 'uuid' : 'googleId'
    let { data, error } = await supabase.from('users').select('*').eq(typeId, tempId);
    
    if (error) {
      return done(new Error('Error when deserializing: could not find user with provided Google id.'))
    }
    
    let user = {
      uuid: data[0].uuid,
      email: data[0].email,
      language: data[0].language,
      darktheme: data[0].dark_theme,
      googleName: data[0].google_name,
      avatarVariant: data[0].avatar_variant,
      avatarColors: data[0].avatar_colors
    }
    done(null, user);
  });
};
