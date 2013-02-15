Syncable = require './syncable.js'

module.exports = class Event extends Syncable
	constructor: (@what, @when, @where="", @who="", @category="") ->
		super()
		@type="Event"

	hasOccurred: ->
		now = getNowInGMT()
		now > @when.getTime()
