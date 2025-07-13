import 'package:flutter/material.dart';
import 'package:stock_manager/Frontend/se_connecter.dart';
import 'package:stock_manager/Frontend/main.dart';

import 'Acceuil.dart'; // Pour retour logo si besoin

class PageInscription extends StatefulWidget {
  const PageInscription({super.key});

  @override
  _PageInscriptionState createState() => _PageInscriptionState();
}

class _PageInscriptionState extends State<PageInscription> {
  final _formKey = GlobalKey<FormState>();

  String nomComplet = '';
  String email = '';
  String motDePasse = '';
  String confirmationMotDePasse = '';

  bool cacherMotDePasse = true;
  bool cacherConfirmation = true;

  final Color texteNoir = Colors.black;
  final Color fond = const Color(0xFFFAFAFA);
  final Color bleu = const Color(0xFF0A1F56);
  final Color gris = Colors.grey.shade600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fond,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/logo_bluecarre.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            //const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nom complet
                  _champTexte(
                    label: "Nom complet",
                    prefixIcon: Icons.person,
                    onChanged: (val) => nomComplet = val,
                  ),
                  const SizedBox(height: 15),

                  // Email
                  _champTexte(
                    label: "Adresse Email",
                    prefixIcon: Icons.email,
                    clavier: TextInputType.emailAddress,
                    onChanged: (val) => email = val,
                  ),
                  const SizedBox(height: 15),

                  // Mot de passe
                  _champTexte(
                    label: "Mot de passe",
                    prefixIcon: Icons.lock,
                    cacher: cacherMotDePasse,
                    suffix: IconButton(
                      icon: Icon(
                        cacherMotDePasse ? Icons.visibility_off : Icons.visibility,
                        color: gris,
                      ),
                      onPressed: () {
                        setState(() => cacherMotDePasse = !cacherMotDePasse);
                      },
                    ),
                    onChanged: (val) => motDePasse = val,
                  ),
                  const SizedBox(height: 15),

                  // Confirmation
                  _champTexte(
                    label: "Confirmer le mot de passe",
                    prefixIcon: Icons.lock_outline,
                    cacher: cacherConfirmation,
                    suffix: IconButton(
                      icon: Icon(
                        cacherConfirmation ? Icons.visibility_off : Icons.visibility,
                        color: gris,
                      ),
                      onPressed: () {
                        setState(() => cacherConfirmation = !cacherConfirmation);
                      },
                    ),
                    onChanged: (val) => confirmationMotDePasse = val,
                  ),
                  const SizedBox(height: 25),

                  // Bouton S’inscrire
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bleu,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Bienvenue $nomComplet !')),
                          );
                          // TODO: Redirection après inscription
                        }
                      },
                      child: const Text(
                        'S’inscrire',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // OU
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color(0xFF0A1F56))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("ou", style: TextStyle(color: Colors.black)),
                      ),
                      Expanded(child: Divider(color: Color(0xFF0A1F56))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Google
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Image.asset('assets/google.jpeg', height: 20),
                      label:  Text('Continuer avec Google', style: TextStyle(color: texteNoir)),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Facebook
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Image.asset('assets/facebook.jpeg', height: 20),
                      label:  Text('Continuer avec Facebook', style: TextStyle(color: texteNoir)),
                      onPressed: () {},
                    ),
                  ),

                  const SizedBox(height: 24),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Vous avez déja un compte ? ', style: TextStyle(color: gris)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SeConnecter(nomComplet: ''),
                            ),
                          );
                        },
                        child: Text(
                          ' Se Connecter',
                          style: TextStyle(color: bleu, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Navigation flèches
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: bleu,
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const SeConnecter(nomComplet: '')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        color: bleu,
                        iconSize: 30,
                        onPressed: () {
                          // TODO: Changer cette ligne vers ta page Home
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const AccueilPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _champTexte({
    required String label,
    required IconData prefixIcon,
    required Function(String) onChanged,
    TextInputType clavier = TextInputType.text,
    bool cacher = false,
    Widget? suffix,
  }) {
    const Color bleu = Color(0xFF0A1F56);
    final Color gris = Colors.grey.shade600;

    return TextFormField(
      obscureText: cacher,
      keyboardType: clavier,
      onChanged: onChanged,
      cursorColor: bleu,  // Curseur bleu
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: TextStyle(color: bleu),  // Label flottant bleu quand focus
        prefixIcon: Icon(prefixIcon, color: gris),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: gris),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: gris),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: bleu, width: 2),  // Bordure bleue au focus
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
