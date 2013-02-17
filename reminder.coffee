Syncable = require './syncable.js'

module.exports = class Reminder extends Syncable
	constructor: (@when, @message="Default", @category="") ->
		super()
		@type="Reminder"
		@repeat = {
			year: 0,
			month: 0,
			days: 0,
			hours: 0
		}
		@mechanisms = ["mail","tweet","sms","other"]
		@addresses = ["simon@home.simonf.net","seymourmania","+447960308451","pi-chime"]
		@shouldRun = true

	shouldExecute: ->
		now = new Date()
		@shouldRun and now.getUTCFullYear() == @when.getUTCFullYear() and now.getUTCMonth() ==  @when.getUTCMonth() and now.getUTCDate() == @when.getUTCDate and now.getUTCHours() == @when.getUTCHours and now.getUTCMinutes >= @when.getUTCMinutes

	executed: ->
		@shouldRun = false
		if @repeat.year > 0 or @repeat.month > 0 or @repeat.days > 0 or @repeat.hours > 0
			@when.setFullYear @when.getFullYear()+@repeat.year
			@when.setMonth @when.getMonth()+@repeat.month
			@when.setTime @when.getTime()+@repeat.days*24*3600*1000
			@when.setTime @when.getTime()+@repeat.hours*3600*1000
			@shouldRun = true

	copy_from: (obj)->
		super(obj)
		if typeof obj.when == 'string'
			@when = new Date parseInt obj.when