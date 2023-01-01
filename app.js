const express = require('express');
const session = require('express-session');
const app = express();

const passport = require('passport');

var cors = require('cors');

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
require('./passportConfigSerialize.js')(passport);
require('./passportConfigGoogle.js')(passport);
require('./passportConfigLocal.js')(passport);
//Passport_________________________________________________________________________________________________


//Cors_________________________________________________________________________________________________
// Needed because the POST request has custom header to send JSON object
app.options('/auth/local/login', cors()) 
app.options('/auth/local/register', cors()) 
app.options('/users', cors()) 

var corsOptions = {
	origin: 'http://localhost:3001',
	optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
};
app.use(cors(corsOptions))
//Cors_________________________________________________________________________________________________

app.use('/auth/google', require('./routes/authGoogle'));
app.use('/auth/local', require('./routes/authLocal'));
app.use('/users', require('./routes/users'))
app.use('/avatars', require('./routes/avatars'))
app.use('/recipes', require('./routes/recipes'))
app.use('/recipes', require('./routes/lists'))

app.get('/logout', (req, res) => {
	req.logout(function(err) {
    if (err) { return next(err); }
    res.redirect('http://localhost:3001/');
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, console.log(`Server started on port ${PORT}`));
