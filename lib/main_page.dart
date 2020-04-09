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
  String barcode = "";
  String resultat = "";

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
                new Container(
                  child: Container(
                    height: 120.0,
                    child:
                    new Dialog()
                  ),
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
      setState(() => this.resultat = resultat);
    } catch(e) {
      setState(() => this.resultat = 'Erreur inconnue: $e');
    }
  }

  Future getData(param) async {
    const url = "http://d999ad2e.ngrok.io/?qrcode=";
    var uri = url + param;
    print("uri = "+uri);
    http.Response reponse = await http.get(Uri.encodeFull(uri));
    print("reponse = "+reponse.body);
    return reponse.body;
  }
}