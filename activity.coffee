Syncable = require './syncable.js'

module.exports = class Activity extends Syncable
	constructor: (@what='Default', @category='', @when = new Date(), @quantity ="") ->
		super()
		@type="Activity"

	copy_from: (obj) ->
		super(obj)
		if typeof obj.when == 'string'
			@when = new Date parseInt obj.when