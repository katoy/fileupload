
app = require './app'

argv = process.argv.slice(2)
port = argv[0] || process.env.PORT || 3000

app.start port

