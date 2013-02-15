Syncable = require './syncable.js'

module.exports = class Memory extends Syncable
	constructor: (@what, @categories=[]) ->
		super()
		@type="Memory"
