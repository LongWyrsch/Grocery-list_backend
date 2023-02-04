const app = require('./app.js');

if (process.env.NODE_ENV !== 'production') {
	require('dotenv').config();
}

const PORT = process.env.PORT || 3000;
app.listen(PORT, console.log(`Server started on port ${PORT}`));


// Containing the app.js into a separate module from the PORT prevented the following test runner warning:
// "Jest has detected the following 1 open handle potentially keeping Jest from exiting TCPSERVERWRAP"
// This cause the test not too exit, so watchAll didn't work.