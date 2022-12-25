const LocalStrategy = require('passport-local').Strategy;
const bcrypt = require('bcrypt');

const supabase = require('./supabase');

module.exports = function (passport) {
  passport.use(
    new LocalStrategy({ usernameField: 'email' }, async function (email, password, done) {

      //Check if can match provided email with one of our users in the database.
      db.query('SELECT * FROM users WHERE email=$1', [email], async (error, results) => {
        if (error) {
          throw error;
        } 
        if (results.rows.length === 0) {
          return done(null, false, { message: 'No user with that email' });
        } else {
          const user = results.rows[0];
          try {
            if (await bcrypt.compare(password, user.password)) {
              return done(null, user);
            } else {
              //Email matched, but password did not match a user in our database.
              return done(null, false, { message: 'Password incorrect' });
            }
          } catch (error) {
            return done(error);
          }
        }
      });
    })
  );

  passport.serializeUser((user, done) => {
    done(null, user.id);
  });

  passport.deserializeUser((id, done) => {
    db.query('SELECT * FROM users WHERE id=$1', [id], (error, results) => {
      if (error) {
        throw error;
      } else {
        const user = results.rows[0];
        done(null, user);
      }
    });
  });
};
