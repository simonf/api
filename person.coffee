Syncable = require './syncable'

module.exports = class Person extends Syncable
	constructor: (@name, @email=[], @phone=[], @other="", @category="") ->
		super()
		@type="Person"
