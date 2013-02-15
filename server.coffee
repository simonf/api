util = require 'util'
express = require 'express'
db = require './db.js'
Activity = require './activity.js'
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

app.use express.static __dirname + '/public'
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use logErrors
app.use clientErrorHandler
app.use errorHandler

app.get "/reminders", (req,res) ->
	db.all 'reminders',\
		((arr) -> res.send arr), \
		((err) -> 
			res.status 500
			res.send err
		)

app.post "/reminder", (req,res) ->
	res.send 501

app.post "/activity", (req,res) ->
	b= req.body
	b.type = "Activity"
	a = new Activity()
	a.copy_from b
	db.save 'activities',a,\
		((doc) -> res.send 200), \
		((err) -> 
			res.status 500
			res.send err
		)

app.listen 2000


