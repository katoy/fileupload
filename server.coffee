
app = require './app'

argv = process.argv.slice(2)
argv = [3000] if argv.length == 0

port = argv[0] || process.env.PORT
app.start port

