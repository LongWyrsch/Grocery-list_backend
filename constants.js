const production = {
	client_url: 'https://mygrocerylists.netlify.app',
	cookie: {
		sameSite: 'none',
		secure: true,
		maxAge: 1000 * 60 * 60 * 24 * 7, //One week
	}
};

const development = {
	client_url: 'http://localhost:3001',
	cookie: null
};

module.exports.config = process.env.NODE_ENV === 'development' || process.env.NODE_ENV === 'test' ? development : production;

// process.env.NODE_ENV is undefined. 
// I have to specify in "start": "export NODE_ENV='development' && nodemon app.js"

// I'm not sure what is the value of process.env.NODE_ENV when running "npm start"... 