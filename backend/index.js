var express = require('express');
var app = express();
var mysql = require('mysql');

// '/' est la route racine
app.get('/', function (req, res) {
    // connexion à la base de donnée
    var mySqlClient = mysql.createConnection({
        host     : "localhost",
        user     : "root",
        password : "",
        database : "go_style_project_db"
    });

    mySqlClient.query(
        "SELECT code FROM codes_promo WHERE uuid = '98670694493061125'",       // réponse attendue CODETEST1
        function select(error, results) {
            if (error) {
                console.log('error SQL :',error);
                mySqlClient.end();
                return;
            }
            
            if ( results.length > 0 )  { 
                var firstResult = results[0];
                res.send(firstResult);
                console.log('reponse : ',firstResult);
                
            } else {
                res.send('Pas de données');
                console.log('reponse : ',"Pas de données");
            }
            mySqlClient.end();
        }
    );
});

app.listen(4000, function () {
    console.log("En écoute sur le port 4000");
});