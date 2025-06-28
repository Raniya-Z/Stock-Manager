import 'package:flutter/material.dart';
import 'package:stock_manager/Frontend/main.dart';
import 'package:stock_manager/Frontend/se_connecter.dart';


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

  final Color fond = Color(0xFFFAFAFA);
  final Color bleu = Color(0xFF0A1F56);
  final Color rose = Color(0xFFE61580);
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
                'assets/logo2.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nom
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

                  // Bouton
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
                        }
                      },
                      child: const Text(
                        'S’inscrire',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // OU
                  Row(
                    children: [
                      Expanded(child: Divider(color: rose)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("ou", style: TextStyle(color: Colors.black)),
                      ),
                      Expanded(child: Divider(color: rose)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Google
                  OutlinedButton.icon(
                    icon: Image.asset('assets/google.jpeg', height: 20),
                    label: const Text("Continuer avec Google", style: TextStyle(color: Colors.black)),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),

                  // Facebook
                  OutlinedButton.icon(
                    icon: Image.asset('assets/facebook.jpeg', height: 20),
                    label: const Text("Continuer avec Facebook", style: TextStyle(color: Colors.black)),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),

                  // Lien vers login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Déjà inscrit ? ', style: TextStyle(color: gris)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SeConnecter(nomComplet: '')),
                          );
                        },
                        child: Text('Connexion',
                            style: TextStyle(color: rose, fontWeight: FontWeight.bold)),
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
    return TextFormField(
      obscureText: cacher,
      keyboardType: clavier,
      onChanged: onChanged,
      cursorColor: gris,
      decoration: InputDecoration(
        labelText: label,
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
          borderSide: BorderSide(color: gris),
        ),
      ),
    );
  }
}
