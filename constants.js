const production = {
	client_url: 'https://mygrocerylists.netlify.app'
};

const development = {
	client_url: 'http://localhost:3001'
};

module.exports.config = process.env.NODE_ENV === 'development' ? development : production;


// process.env.NODE_ENV is undefined. 
// I have to specify in "start": "export NODE_ENV='development' && nodemon app.js"