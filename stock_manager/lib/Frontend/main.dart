import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stock_manager/Frontend/se_connecter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const MaterialColor bleuPerso = MaterialColor(
    0xFF0A1F56,
    <int, Color>{

      500: Color(0xFF0A1F56), // ta couleur principale

    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAFAFA), // fond clair
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        primarySwatch: bleuPerso,
      ),
      home: const FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SeConnecter(nomComplet: 'Nom Complet')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F56),
      body: Center(
        child: Image.asset(
          'assets/logo1_white.png',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
