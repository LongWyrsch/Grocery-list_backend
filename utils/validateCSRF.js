const validateCSRF = (req,res,next) => { 
	if (req.body.CSRF_token !== req.session.CSRF_token) {
		res.status(401).send()
		return
	}
    next()
}


module.exports = validateCSRF