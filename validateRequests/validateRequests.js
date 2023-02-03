// import { validationResult } from "express-validator"
const { validationResult } = require('express-validator');

const validateRequests = (req, res, next) => {
	const errors = validationResult(req);

	if (!errors.isEmpty()) {
		console.log('validationResults, errors: ', errors);
		return res.status(400).send({ errors: errors.array() });
	}
	next();
};

module.exports = validateRequests;
