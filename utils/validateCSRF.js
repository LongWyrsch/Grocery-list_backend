const validateCSRF = (req,res,next) => { 
	if (req.body.CSRF_token !== req.session.CSRF_token) {
		console.log('CSRF_token don\'t match')
		res.status(401).send()
		return
	}
    next()
}


module.exports = validateCSRF