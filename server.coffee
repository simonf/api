util = require 'util'
express = require 'express'
db = require './db'
Activity = require './activity'
Event = require './event'
app = express()


logErrors = (err, req, res, next) ->
	console.error err.stack
	next err

clientErrorHandler = (err, req, res, next) ->
	if req.xhr
		res.send 500, { error: 'Something blew up!' }
	else
		next err

errorHandler = (err, req, res, next) ->
	res.status 500
	res.render 'error', { error: err }

getAllOfType = (otype, res) ->
	db.all otype, \
		((arr) -> res.send arr), \
		((err) -> 
			res.status 500
			res.send err
			console.log err
		)	

saveSyncable = (input_object, vanilla_object, res) ->
	console.log input_object
	input_object.type = vanilla_object.type
	vanilla_object.copy_from input_object
	db.save vanilla_object, \
		((doc) -> res.send 200), \
		((err) -> 
			res.status 500
			res.send err
		)

app.use express.static __dirname + '/public'
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use logErrors
app.use clientErrorHandler
app.use errorHandler

app.get "/reminders", (req,res) ->
	getAllOfType 'Reminder', res

app.post "/reminder", (req,res) ->
	saveSyncable req.body, new Reminder(), res

app.get "/activities", (req,res) ->
	getAllOfType 'Activity', res

app.post "/activity", (req,res) ->
	saveSyncable req.body, new Activity(), res

app.get "/events", (req,res) ->
	getAllOfType 'Event', res

app.post "/event", (req,res) ->
	saveSyncable req.body, new Event(), res

# make sure views exist
db.init()
app.listen 2000


