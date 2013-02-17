cradle = require 'cradle'


exports.connect = (dbname, callback) ->
	db = new(cradle.Connection)().database dbname
	db.exists (err, exists) ->
		if err?
			console.log "error", err
			callback null
		else if exists 
			callback db
		else 
			console.log "database does not exist."
			db.create()
			callback db
			#populate design documents */

exports.save = (dbname, obj, callback, errh) ->
	this.connect dbname, (db) ->
		db.get obj.guid, (err,doc) ->
			if err 
				db.save obj.guid, obj, (err,res) ->
					if err
						errh err
					else
						callback res
			else
				console.log "Found #{obj.guid}"
				db.save obj.guid, doc._rev, obj, (err,res) ->
					if err
						errh err
					else
						callback res

exports.get = (dbname, guid, callback, errh) ->
	this.connect dbname, (db) ->
		db.get guid, (err, doc) ->
			if err then errh err else callback doc

exports.delete = (dbname, guid, callback, errh) ->
	this.connect dbname, (db) ->
		db.get guid, (err,doc) ->
			if err
				console.log err
				errh err
			else
				db.remove guid, doc._rev, (err,res) ->
					if err then errh err else callback res

exports.all = (dbname, callback, errh) ->
	this.connect dbname, (db) ->
		db.view "#{dbname}/all", (err, res) ->
			if err
				errh err
			else
				reta = []
				res.forEach (row) ->
					reta.push row
				callback reta
