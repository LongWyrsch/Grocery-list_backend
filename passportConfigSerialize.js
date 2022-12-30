const supabase = require('./supabase');

module.exports = function (passport) {
  passport.serializeUser((user, cb) => {
    userIds = {
      uuid: user.uuid,
      googleId: user.googleId
    }
    cb(null, userIds);
  });

  passport.deserializeUser(async (userIds, cb) => {
    let tempId = userIds.uuid ? userIds.uuid : userIds.googleId
    let typeId = userIds.uuid ? 'uuid' : 'googleId'
    let { data, error } = await supabase.from('users').select('*').eq(typeId, tempId);

    if (error) {
      return cb(new Error('Error when deserializing: could not find user with provided Google id.'))
    }

    let user = data[0]
    cb(null, user);
  });
};
