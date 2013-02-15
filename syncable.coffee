module.exports = class Syncable
	constructor: ->
		@creationTimestamp = this.getNowInGMT()
		@guid = this.makeGUID()
		@changedTimestamp = @creationTimestamp
		@deletedTimestamp = 0
		@type="Syncable"

	copy_from: (obj) ->
		return if obj.type != @type and console.log "Not copying #{obj.type} to #{@type}"
		for k,v of this
			t = typeof this[k]
			if 'function' != t
				tk = typeof obj[k]
				if t == tk or (t=='undefined' and tk != 'undefined')
					console.log "#{this[k]} <- #{obj[k]}"
					this[k] = obj[k]

	getNowInGMT: ->
		now = new Date()
		(new Date now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(),  now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds()).getTime()

	# Algorithm from http://stackoverflow.com/a/8809472
	makeGUID: ->
		d = this.getNowInGMT()
		uuid = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
			r = (d + Math.random()*16)%16 | 0
			d = Math.floor d/16
			(if c == 'x' then r else (r&0x7|0x8)).toString(16)

	delete: ->
		@deletedTimestamp = this.getNowInGMT()
		@changedTimestamp = @deletedTimestamp;

	touch: ->
		@changedTimestamp = this.getNowInGMT()

	isDeleted: ->
		@deletedTimestamp > 0

	equals: (arg0) ->
		if arg0 not instanceof Syncable 
			return false
		if @guid != arg0.guid 
			return false
		if @creationTimestamp != arg0.creationTimestamp
			return false
		if @changedTimestamp != arg0.changedTimestamp
			return false
		if @deletedTimestamp != arg0.deletedTimestamp
			return false
		return true;

	prefer: (s1, s2) ->
		if s1==null and s2==null  
			return null
		else if s1==null 
			return s2
		else if s2==null 
			return s1
		else 
			if s1.guid != s2.guid
				throw {error: "GUIDs do not match."}
			
			#Deletion processing: only execute these rules if either object has a deleted timestamp
			if s1.deletedTimestamp > 0 or s2.deletedTimestamp > 0
				# If one object has a deleted timestamp more recent than the other's last change, return it
				if s1.deletedTimestamp >= s2.changedTimestamp then return s1
				if s2.deletedTimestamp >= s1.changedTimestamp then return s2
	
				# If one object has a change more recent than the other's deleted timestamp, return it
				if s1.changedTimestamp > s2.deletedTimestamp and s2.deletedTimestamp > 0  
					return s1
				if s2.changedTimestamp > s1.deletedTimestamp and s1.deletedTimestamp>0 
					return s2
			
			#Change processing
			if s1.changedTimestamp > s2.changedTimestamp then return s1
			if s2.changedTimestamp > s1.changedTimestamp then return s2
			
			#Identical
			return s1
