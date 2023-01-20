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

const emailSchema = Joi.object({
	email: Joi.string().min(6).required().messages({
		// 'string.base': `"email" should be a type of 'text'`,
		'string.min': `minimum`,
		// 'any.required': `Username or email is required`
	}),
});

const passwordSchema = Joi.object({
	password: Joi.string()
		.min(6)
		.pattern(/^[\w[\]`!@#$%^&*()={}:;<>+'-]+$/)
		.required()
		.messages({
			// 'string.base': `"password" should be a type of 'text'`,
			'string.min': `minimum`,
			'string.pattern.base': `pattern`,
			// 'any.required': `Password is required`
		}),
});


module.exports.signupValidation = validator(registerSchema);
module.exports.signinValidation = validator(signinSchema);
exports.emailValidation = validator(emailSchema);
exports.passwordValidation = validator(passwordSchema);
