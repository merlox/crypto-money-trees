const express = require('express')
const app = require('express')()
const { join } = require('path')
const port = 8000
const ip = '0.0.0.0'

app.use(express.static(join(__dirname, 'dist')))

app.get('*', (req, res) => {
	res.sendFile(join(__dirname, 'dist', 'index.html'))
})

app.listen(port, ip, (req, res) => {
	console.log(`Listening on ${ip}:${port}`)
})
