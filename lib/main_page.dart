import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {

  // Déclaration variable globale
  String barcode = "";

  @override
  initState() {
    super.initState();
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
      String barcode = await BarcodeScanner.scan();
      print("barcode "+barcode);
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
    const url = "http://7d3e2eb7.ngrok.io/?qrcode=";
    var uri = url + param;
    http.Response reponse = await http.get(Uri.encodeFull(uri));
    return reponse.body;
  }

  // Focntion recevant le résultat de l'API et l'affichant en pop-up
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
          )
        ],
      );
    });
  }
}