Syncable = require './syncable.js'

module.exports = class Rule extends Syncable
	constructor: (@name, @condition, @action, @category="") ->
		super()
		@type="Rule"

	isConditionTrue: (env) ->
		if 'function' == typeof @condition
			@condition env
		else
			console.log "Error executing rule #{@name}: no condition function found"
			false

	execute: (env) ->
		if 'function' == typeof @action
			@action env
		else
			console.log "Error executing rule #{@action}: no action function found"
			false
