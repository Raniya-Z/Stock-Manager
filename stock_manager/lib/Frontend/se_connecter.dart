import 'package:flutter/material.dart';
import 'package:stock_manager/Frontend/s_inscrire.dart';
import 'package:stock_manager/Frontend/main.dart'; // Pour retour au logo

class SeConnecter extends StatefulWidget {
  final String nomComplet;

  const SeConnecter({super.key, required this.nomComplet});

  @override
  _SeConnecterState createState() => _SeConnecterState();
}

class _SeConnecterState extends State<SeConnecter> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String motDePasse = '';
  bool cacherMotDePasse = true;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    // Couleurs
    const Color fond = Color(0xFFFAFAFA);
    const Color bleu = Color(0xFF0A1F56);
    const Color champFond = Colors.white;
    const Color texteNoir = Colors.black;
    final Color gris = Colors.grey.shade600;

    return Scaffold(
      backgroundColor: fond,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo en haut centré
           //   const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/logo_bluecarre.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              //const SizedBox(height: 10),

              // Formulaire
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: texteNoir),
                      decoration: InputDecoration(
                        labelText: 'Adresse Email',
                        labelStyle: TextStyle(color: gris),
                        prefixIcon: Icon(Icons.email, color: gris),
                        filled: true,
                        fillColor: champFond,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Entrez un email';
                        if (!val.contains('@') || !val.contains('.')) return 'Email invalide';
                        return null;
                      },
                      onChanged: (val) => setState(() => email = val),
                    ),

                    const SizedBox(height: 16),

                    // Mot de passe
                    TextFormField(
                      obscureText: cacherMotDePasse,
                      style: const TextStyle(color: texteNoir),
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(color: gris),
                        prefixIcon: Icon(Icons.lock, color: gris),
                        suffixIcon: IconButton(
                          icon: Icon(
                            cacherMotDePasse ? Icons.visibility_off : Icons.visibility,
                            color: gris,
                          ),
                          onPressed: () => setState(() => cacherMotDePasse = !cacherMotDePasse),
                        ),
                        filled: true,
                        fillColor: champFond,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Entrez un mot de passe';
                        if (val.length < 6) return 'Min. 6 caractères';
                        return null;
                      },
                      onChanged: (val) => setState(() => motDePasse = val),
                    ),

                    const SizedBox(height: 10),

                    // Se souvenir + mot de passe oublié
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Checkbox(
                                value: rememberMe,
                                activeColor: Color(0xFF0A1F56),
                                onChanged: (value) => setState(() => rememberMe = value ?? false),
                              ),
                            ),
                            Text("Se souvenir de moi", style: TextStyle(color: gris)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(
                              color: bleu,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Bouton Se connecter
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bleu,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Bienvenue, ${widget.nomComplet}!')),
                            );
                          }
                        },
                        child: const Text('Se connecter', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // OU
                    Row(
                      children: const [
                        Expanded(child: Divider(color: bleu)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("ou"),
                        ),
                        Expanded(child: Divider(color: bleu)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Google
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: Image.asset('assets/google.jpeg', height: 20),
                        label: const Text('Continuer avec Google', style: TextStyle(color: texteNoir)),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Facebook
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: Image.asset('assets/facebook.jpeg', height: 20),
                        label: const Text('Continuer avec Facebook', style: TextStyle(color: texteNoir)),
                        onPressed: () {},
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Lien inscription
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Vous n'avez pas de compte ?", style: TextStyle(color: gris)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PageInscription()),
                            );
                          },
                          child: const Text(
                            "  S'inscrire",
                            style: TextStyle(color: bleu, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Flèches navigation
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
                              MaterialPageRoute(builder: (context) => const FirstPage()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: bleu,
                          iconSize: 30,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PageInscription()),
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
      ),
    );
  }
}
