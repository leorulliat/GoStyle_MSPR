import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'ListePromo.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {

  // Déclaration variable globale
  String barcode = "";
  String url = "http://a8d84c24.ngrok.io/";
  Future<ListePromos> futureListePromo;

  @override
  initState() {
    super.initState();
    //futureListePromo = getPromos(true);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Go Style'),
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: FutureBuilder<ListePromos>(
                    future: getPromos(),
                    builder: (context, AsyncSnapshot<ListePromos> snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.titre);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    }
                  ),
                ),
                new Container(
                  child: new MaterialButton(
                      onPressed: scan,
                      child: Container(
                        margin: EdgeInsets.only(top: 200),
                          child: new Icon(Icons.add_a_photo, size: 150.0),
                      )
                  ),
                  padding: const EdgeInsets.all(8.0),
                ),
              ],
            ),
          )),
    );
  }

  Future scan() async {
    try {
      //TODO ne pas envoyé si on appuie sur le bouton retour
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = "Vous n''avez pas donné la permission d''utiliser le micro !!";
        });
      } else {
        setState(() => this.barcode = 'Erreur inconnue: $e');
      }
    } on FormatException{
      setState(() => this.barcode = "Vous avez appuyé sur le bouton retour");
    } catch (e) {
      setState(() => this.barcode = 'Erreur inconnue: $e');
    }

    try {
      String resultat = await getData(barcode);
      showPop(context, resultat);
    } catch(e) {
      //TODO demander au prof ce que l'on peut mettre  dans le catch
      //setState(() => this.resultat = 'Erreur inconnue: $e');
    }
  }

  // Méthde intérogeant la base de donnée
  Future getData(param) async {
    var uri = this.url + "?qrcode="+ param;
    http.Response reponse = await http.get(Uri.encodeFull(uri));
    if(reponse.statusCode == 200) {
      return reponse.body;
    }
    else if(reponse.statusCode == 502) {
      return "Serveur inaccessible";
    }
  }

  Future<ListePromos> getPromos() async {
    print("reponse getPromos "+this.url + "?liste=");
    final reponse = await http.get(Uri.encodeFull(this.url + "?liste=true"));
    print("reponse getPromos "+this.url + "?liste=");
    //if(reponse.statusCode == 200) {
      return ListePromos.fromJson(json.decode(reponse.body));
    //}
    /*else {
      return "Un problème est survenu lors de la récupération des promotions en cours";
      //throw Exception("Un problème est survenu lors de la récupération des promotions en cours");
    }*/
  }

  // Fonction recevant le résultat de l'API et l'affichant en pop-up
  showPop(BuildContext context, param) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("CODE PROMO"),
        content: Text(param),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
}