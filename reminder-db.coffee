cradle = require 'cradle'

db = new(cradle.Connection)().database 'reminders'

db.exists (err, exists) ->
    if (err) 
      console.log "error", err
    else if exists 
      console.log "db exists"
    else 
      console.log "database does not exist."
      db.create()
      #populate design documents */

exports.save = (reminder, callback, errh) ->
	db.get reminder.guid, (err,doc) ->
		if err 
			console.log err
			db.save reminder.guid, reminder, (err,res) ->
				if err
					errh err
				else
					callback res
		else
			console.log "Found #{reminder.guid}"
			db.save reminder.guid, doc._rev, reminder, (err,res) ->
				if err
					errh err
				else
					callback res

exports.get = (guid, callback, errh) ->
	db.get guid, (err, doc) ->
		if err then errh err else callback doc

exports.delete = (guid, callback, errh) ->
	db.get guid, (err,doc) ->
		if err
			console.log err
			errh err
		else
			db.remove guid, doc._rev, (err,res) ->
				if err then errh err else callback res

exports.all = (callback, errh) ->
	db.view 'reminders/all', (err, res) ->
		if err
			errh err
		else
			reta = []
			res.forEach (row) ->
				reta.push row
			callback reta
