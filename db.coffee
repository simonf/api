cradle = require 'cradle'
fs = require 'fs'

common_dbname = 'api'

exports.init = ->
	this.connect (db) ->
		makeViews db

exports.connect = (callback) =>
	db = new(cradle.Connection)().database common_dbname
	db.exists (err, exists) =>
		if err?
			console.log "error", err
			callback null
		else if exists 
			callback db
		else 
			console.log "database does not exist."
			db.create()
			callback db

makeViews = (db) ->
	view_id = '_design/api'
	dd = fs.readFileSync 'view-definitions.json', 'utf8'
	design_doc = JSON.parse(dd)
	db.get view_id, (err,dat) ->
		if err
			console.log err
			db.save view_id, design_doc
			console.log "Created views"
			return
		else
			console.log "DB OK"


exports.save = (obj, callback, errh) ->
	this.connect (db) ->
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

exports.get = (guid, callback, errh) ->
	this.connect (db) ->
		db.get guid, (err, doc) ->
			if err then errh err else callback doc

exports.delete = (guid, callback, errh) ->
	this.connect (db) ->
		db.get guid, (err,doc) ->
			if err
				console.log err
				errh err
			else
				db.remove guid, doc._rev, (err,res) ->
					if err then errh err else callback res

exports.all = (obj_type, callback, errh) ->
	this.connect (db) ->
		viewname = "api/all_#{obj_type}"
		console.log "Querying view #{viewname}"
		db.view viewname, (err, res) ->
			if err
				errh err
			else
				reta = []
				res.forEach (row) ->
					reta.push row
				callback reta
