import 'package:flutter/material.dart';
import 'main_page.dart';

// QRCode Generator https://fr.qr-code-generator.com

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
        title: "Go_Style",
        home: MainPage()
    );
  }
}

void main() {
  runApp(App());
}