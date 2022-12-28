const express = require('express');
const session = require('express-session');
const app = express();

const passport = require('passport');

var cors = require('cors');

if (process.env.NODE_ENV !== 'production') {
	require('dotenv').config();
}

// Needed because the POST request has custom header to send JSON object
app.options('/auth/local/login', cors()) 
app.options('/auth/local/register', cors()) 

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
																			const supabase = require('./supabase');

app.use('/auth/google', require('./routes/authGoogle'));
app.use('/auth/local', require('./routes/authLocal'));
app.get('/test', async (req,res,next) => { 
	// let { data, error } = await supabase.from('recipes').select("*").eq('recipe', 'dddd')
	const { data, error } = await supabase.from('recipes').update({ recipe: 'updated name', ingredient: 'updated ingredient' }).eq('uuid', 'acfcf5bc-7a53-4b2a-b20e-c5b6d30ff311')
console.log( data )
  res.send(data)
 })

app.get('/logout', (req, res) => {
	req.logout(function(err) {
    if (err) { return next(err); }
    res.redirect('http://localhost:3001/');
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, console.log(`Server started on port ${PORT}`));
