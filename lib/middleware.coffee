exports.errorHelper = (err) ->
	console.trace err
	if err.name is not 'ValidationError'
		return err

	messages =
		'required': "%s is required"
		'min': "%s is below minimum"
		'max': "%s is above maximum"
		'enum': "%s is not an allowed value"

	errors = []

	Object.keys(err.errors).forEach (field) ->
		eObj = err.errors[field]

		if not messages.hasOwnProperty(eObj.type)
			errors.push eObj.type

		else
			errors.push require('util').format(messages[eObj.type], eObj.path);

	return errors