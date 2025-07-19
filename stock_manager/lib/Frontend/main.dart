




import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stock_manager/Frontend/se_connecter.dart';

import 'theme_provider.dart'; // 👈 importe ton provider
import 'Acceuil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Fond clair
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF0A1F56), // 🌌 Couleur principale unique
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A1F56),
            foregroundColor: Colors.white,
          ),
        ),
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
    // ⏱️ Attente de 3 secondes
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SeConnecter(nomComplet: 'Nom Complet'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F56),
      body: Center(
        child: Image.asset(
          'assets/logo_1page.png',
          width: 350,
          height: 350,
        ),
      ),
    );
  }
}
