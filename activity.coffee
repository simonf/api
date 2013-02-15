Syncable = require './syncable.js'

module.exports = class Activity extends Syncable
	constructor: (@what='Default', @category='', @when = new Date(), @quantity ="") ->
		super()
		@type="Activity"
