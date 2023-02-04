const express = require('express');
const session = require('express-session');
const app = express();

const passport = require('passport');

var cors = require('cors');
const helmet = require('helmet');

if (process.env.NODE_ENV !== 'production') {
	require('dotenv').config();
}
const { config } = require('./constants.js');

//Bodyparser
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Helmet for security-related HTTP headers
app.use(helmet());

app.set('trust proxy', 1); // I don't know what this does.
//Session__________________________________________________________________________________________________
app.use(
	session({
		secret: process.env.SESSION_SECRET,
		resave: false,
		saveUninitialized: false,
		cookie: config.cookie
	})
);
//Session__________________________________________________________________________________________________


//Passport_________________________________________________________________________________________________
app.use(passport.initialize());
app.use(passport.session());

require('./passport/passportConfigGoogle.js')(passport);
require('./passport/passportConfigLocal.js')(passport);
require('./passport/passportConfigSerialize.js')(passport);
//Passport_________________________________________________________________________________________________

//Cors_________________________________________________________________________________________________
var corsOptions = {
	credentials: true,
	preflightContinue: true,
	methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
	origin: config.client_url,
	optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
};

// Needed because the POST request has custom header to send JSON object
app.options('*', cors(corsOptions));
// app.options('/auth/local/signin', cors())
// app.options('/auth/local/signup', cors())
// app.options('/users', cors())
// app.options('/recipes', cors())
// app.options('/lists', cors())

app.use(cors(corsOptions));
//Cors_________________________________________________________________________________________________


app.use('/auth/google', require('./routes/authGoogle'));
app.use('/auth/local', require('./routes/authLocal'));
app.use('/users', require('./routes/users'));
app.use('/recipes', require('./routes/recipes'));
app.use('/lists', require('./routes/lists'));



module.exports = app