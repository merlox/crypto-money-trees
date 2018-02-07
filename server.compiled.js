'use strict';

var _path = require('path');

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var app = (0, _express2.default)();
var port = 8000;
var ip = '0.0.0.0';

app.use('*', function (req, res, next) {
        console.log('Request to ' + req.originalUrl);
        next();
});

app.use(_express2.default.static((0, _path.join)(__dirname, 'dist')));

app.get('*', function (req, res) {
        res.sendFile((0, _path.join)(__dirname, 'dist', 'index.html'));
});

app.listen(port, ip, function (req, res) {
        console.log('Listening on ' + ip + ':' + port);
});
