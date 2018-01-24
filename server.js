import { join } from 'path'
import express from 'express'

const app = express()
const port = 8000
const ip = '0.0.0.0'

app.use('*', (req, res, next) => {
	console.log(`Request to ${req.originalUrl}`)
	next()
})

app.use(express.static(join(__dirname, 'dist')))

app.get('*', (req, res) => {
	res.sendFile(join(__dirname, 'dist', 'index.html'))
})

app.listen(port, ip, (req, res) => {
	console.log(`Listening on ${ip}:${port}`)
})
