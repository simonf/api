Syncable = require './syncable'

module.exports = class Memory extends Syncable
	constructor: (@what, @categories=[]) ->
		super()
		@type="Memory"
