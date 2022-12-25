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
        let { data, error } = await supabase.from('users').select('*').eq('googleId', profile.id);
        if (data.length > 1) {
          //Error. Profile id should be unique.
          console.log('Error: Google profile returned more than one user.');
        } else if (data.length === 0) {
          // add that user
          let language = profile._json.locale.slice(0, 2) === 'en' ? 'ENG' : 'DEU';
          const { data, error } = await supabase.from('users').insert([
            {
              role: 'user',
              language: language,
              darkmode: false,
              googleId: profile.id,
              googleName: profile.displayName,
            },
          ]);

          if (error) {
            console.log(error);
            return;
          }

          user = {
            role: 'user',
            language: language,
            darkmode: false,
            googleId: profile.id,
            googleName: profile.displayName,
          };
        } else {
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

  passport.serializeUser((user, done) => {
    console.log('user serialized');
    done(null, user.googleId);
  });

  passport.deserializeUser(async (googleId, done) => {
    let { data, error } = await supabase.from('users').select('*').eq('googleId', googleId);

    if (error) {
      console.log('Error when deserializing: could not find user with provided Google id.');
    }

    let user = data[0]
    console.log('user DEserialized');
    done(null, user);
  });
};
