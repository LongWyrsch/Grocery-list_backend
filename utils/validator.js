const Joi = require('joi');

const validator = (schema) => (payload) => {
	return schema.validate(payload, {abortEarly: false});
};

const registerSchema = Joi.object({
	email: Joi.string().min(6).required(),
	password: Joi.string().min(6).pattern(/[\w[\]`!@#$%^&*()={}:;<>+'-]*/).required()
});

const signinSchema = Joi.object({
    email: Joi.string().min(6).required(),
    password: Joi.string().min(6).pattern(/[\w[\]`!@#$%^&*()={}:;<>+'-]*/).required()
})

module.exports.signupValidation = validator(registerSchema);
module.exports.signinValidation = validator(signinSchema);
