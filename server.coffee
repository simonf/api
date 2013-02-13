express = require 'express'
remdb = require './reminder-db.js'
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


app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use logErrors
app.use clientErrorHandler
app.use errorHandler

app.get "/reminders", (req,res) ->
	remdb.all \
		((arr) -> res.send arr), \
		((err) -> 
			res.status 500
			res.send err
		)


app.post "/reminder", (req,res) ->
	res.send 501


app.listen 2000


