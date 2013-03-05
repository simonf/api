Syncable = require './syncable'

module.exports = class Event extends Syncable
	constructor: (@what, @when, @where="", @who="", @category="") ->
		super()
		@type="Event"

	copy_from: (obj) ->
		super(obj)
		if typeof obj.when == 'string'
			@when = new Date parseInt obj.when

	hasOccurred: ->
		now = getNowInGMT()
		now > @when.getTime()
