var express = require('express');
var app = express();

// '/' est la route racine
app.get('/', function (req, res) {
    res.send("hello world!");
});

app.listen(4000, function () {
    console.log("En écoute sur le port 4000");
});