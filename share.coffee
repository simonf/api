Syncable = require './syncable'

module.exports = class Share extends Syncable
	constructor: (@info="Default", @person=[], @when=new Date(), @how=["email"]) ->
		super()
		@type="Share"
		@shouldNotify = true

	shouldTell: ->
		now = new Date()
		@shouldNotify and now.getUTCFullYear() == @when.getUTCFullYear() and now.getUTCMonth() ==  @when.getUTCMonth() and now.getUTCDate() == @when.getUTCDate and now.getUTCHours() == @when.getUTCHours and now.getUTCMinutes >= @when.getUTCMinutes

	told: ->
		@shouldNotify = false
