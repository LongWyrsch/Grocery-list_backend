const express = require('express');
const session = require('express-session');
const app = express();

const passport = require('passport');

if (process.env.NODE_ENV !== 'production') {
  require('dotenv').config();
}

//Bodyparser
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

//Session__________________________________________________________________________________________________
app.use(
  session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
  })
);
//Session__________________________________________________________________________________________________

app.use(passport.initialize());
app.use(passport.session());

//Passport_________________________________________________________________________________________________
require('./passportConfigGoogle.js')(passport);
//Passport_________________________________________________________________________________________________


app.use('/auth/google', require('./routes/authGoogle'));
app.use('/auth/local', require('./routes/authLocal'));


app.get("/logout", (req, res) => {  
  req.logout();  
  res.redirect("/");  
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, console.log(`Server started on port ${PORT}`));
