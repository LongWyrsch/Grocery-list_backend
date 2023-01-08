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
    
    let user = data[0]
    done(null, user);
  });
};
