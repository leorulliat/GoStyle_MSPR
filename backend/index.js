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

    const promise1 = new Promise(function(resolve,reject){
        //dans un premier temps, récupération du paramètre contenant le contenu du qrcode
        var qrcode = req.param('qrcode');
        if(qrcode != undefined){
            var entete = qrcode.split('_')[0];
            var uuid = qrcode.split('_')[1];
            if(entete == "gostylecode"){
                resolve(uuid);  //renvois de l'identifiant du code promo présent dans le qrcode
            } else {
                reject("Ce QRCode n\'appartient pas à Go Style");
            }
        }  else {
            reject("url invalide");
        }
        
    })
    .then(function(uuid){
        
        var selectQuery = 'CALL get_code_promo(' + uuid + ');';
         //initialisation de la variable contenant l'appel à la procédure stockée get_code_promo
        //cette dernière retourne le code promo correspondant à l'identifiant passé en paramètre, si la date de validité du code promo est correcte
        console.log('Requete SQL : ',selectQuery);

        mySqlClient.query(      //execution de la requête
            selectQuery,
            function select(error, results) {
                if (error) {
                    console.log('error SQL :',error);
                    mySqlClient.end();
                    return;
                }
                
                if ( results.length > 0 )  { 
                    var firstResult = results[0];
                    res.send(firstResult[0]['code']); 
                    console.log('reponse : ',firstResult[0]['code']);
                    
                } else {
                    res.send('Pas de données');
                    console.log('reponse : ',"Pas de données");
                }
                mySqlClient.end();
            }
        );
    })
    .catch(function(error){
        console.log('reponse : ', error);
        res.send(error);
    });
});

app.listen(4000, function () {
    console.log("En écoute sur le port 4000");
});