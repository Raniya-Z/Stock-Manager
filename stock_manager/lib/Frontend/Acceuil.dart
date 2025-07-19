import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager/Frontend/alertes_stock.dart';
import 'package:stock_manager/Frontend/historique_stock.dart';
import 'package:stock_manager/Frontend/se_connecter.dart';
import 'package:stock_manager/Frontend/sorties_stock.dart';
import 'entrees_stock.dart';
import 'produits_categories.dart'; // assure-toi que le chemin est correct
import 'ajouter_produits.dart';





class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}
//final TextEditingController codeBarreController = TextEditingController();
class _AccueilPageState extends State<AccueilPage> {
  final Color bleu = const Color(0xFF0A1F56);
  final Color fond = const Color(0xFFFAFAFA);
  int selectedIndex = -1;
  File? _imageFile;
  bool _isDarkMode = false;

  final List<IconData> icons = [
    Icons.inventory_outlined,
    Icons.add_box_outlined,
    Icons.input_outlined,
    Icons.output_outlined,
    Icons.history_outlined,
    Icons.notifications_on_outlined,
  ];
  //photo
  @override
  void initState() {
    super.initState();
    _loadImageFromPrefs();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/profile_image.png';
      final imageFile = File(picked.path);
      await imageFile.copy(imagePath);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', imagePath);

      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> _loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image');
    if (path != null && await File(path).exists()) {
      setState(() {
        _imageFile = File(path);
      });
    }
  }
//se deconnecter
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Confirmation", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Voulez-vous vraiment vous déconnecter ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:  Text("Annuler", style: TextStyle(color:bleu)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Ferme la boîte de dialogue

              // 🔴 Efface les données de session si besoin (ex : token, utilisateur...)
              // final prefs = await SharedPreferences.getInstance();
              // await prefs.clear();

              // 🔁 Redirige vers la page de connexion
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const  SeConnecter(nomComplet: '',)),
                    (route) => false,
              );
            },
            child:  Text("Se déconnecter", style: TextStyle(color: Colors.red[800])),
          ),
        ],
      ),
    );
  }


  /*void _scannerCodeBarre() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text("Scanner le code-barres"),
            backgroundColor: bleu,
          ),
          body: MobileScanner(
            onDetect: (capture) {
              if (capture.barcodes.isNotEmpty) {
                final barcode = capture.barcodes.first;
                final code = barcode.rawValue ?? '';
                if (code.isNotEmpty) {
                  if (mounted) {
                    setState(() {
                      codeBarreController.text = code;
                    });
                  }
                  Navigator.pop(context);
                }
              }
            },
          ),
        ),
      ),
    );
  }

*/



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fond,

      drawer: Drawer(
        backgroundColor: bleu,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/logo_1page.png',
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white54, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(8),
                                    image: _imageFile != null
                                        ? DecorationImage(
                                      image: FileImage(_imageFile!),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                                  ),
                                  child: _imageFile == null
                                      ? const Icon(Icons.person_pin, size: 30, color: Colors.white)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.edit, size: 6, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Nom Admin',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildPersonalInfoDropdown(),
                  _buildDarkModeDropdown(),
                  _buildDrawerItem(Icons.logout, 'Se déconnecter', () => _confirmLogout()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Gestion de mon compte',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),


      appBar: AppBar(
        backgroundColor: bleu,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: fond),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Accueil',
          style: TextStyle(
            color: fond,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          // ✅ Barre de recherche + bouton scan à droite
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Champ de recherche
                Expanded(
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF0A1F56), width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Chercher un produit...",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

      Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFF0A1F56), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),

        child: const Icon(Icons.qr_code_scanner, color: Color(0xFF0A1F56), size: 18),
                /*Container(
                  margin: const EdgeInsets.only(bottom: 12, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFF0A1F56), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: codeBarreController,
                    cursorColor: Color(0xFF0A1F56),
                    style: const TextStyle(color: Color(0xFF0A1F56)),
                    decoration: InputDecoration(
                      labelText: "Code-barres",
                      labelStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF0A1F56), size: 20),
                        onPressed: _scannerCodeBarre,
                      ),
                    ),
                  ),

                 */
                ),

              ],
            ),
          ),

          const SizedBox(height: 30),

          // ✅ Conteneurs mères
          ...List.generate(3, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: fond,
                border: Border.all(color: fond, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSmallContainer(i * 2),
                  const SizedBox(width: 55),
                  _buildSmallContainer(i * 2 + 1),
                ],
              ),
            );
          }),
        ],
      ),

    );
  }
//les indexes = les container petites
  Widget _buildSmallContainer(int index) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        //index0=mes produits
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProduitsCategories()),
          );
        }
        //index1=ajouter un nouveau produit
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AjouterProduitPage(initialCategories: [],)),
          );
        }
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>const  EntreesStockPage(initialCategories: [],initialProduits: [])),
          );
        }
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>const  SortiesStockPage(initialCategories: [],initialProduits: [])),
          );
        }
        if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  HistoriqueStockPage()),
          );
        }
        if (index == 5) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlertesStockPage()),
          );
        }
      },

      child: Container(
        width: 130,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? bleu : Colors.white,
          border: Border.all(color: bleu, width: 6),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          icons[index],
          size: 40,
          color: isSelected ? Colors.white : bleu,
        ),
      ),
    );
  }


  bool _editNom = false;
  bool _editEmail = false;
  bool _editPassword = false;

  TextEditingController _nomController = TextEditingController(text: "");
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _passwordController = TextEditingController(text: "");

  Widget _buildPersonalInfoDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Row(
              children: const [
                Icon(Icons.person, color: Colors.white),
                SizedBox(width: 12),
                Expanded( // 👈 Ajouté pour éviter overflow
                  child: Text(
                    'Informations personnelles',
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis, // 👈 pour éviter dépassement texte
                  ),
                ),
              ],
            ),
            children: [
              _buildEditableField(
                label: "Nom d'admin",
                controller: _nomController,
                isEditing: _editNom,
                onEditToggle: () => setState(() => _editNom = !_editNom),
              ),
              _buildEditableField(
                label: "Email",
                controller: _emailController,
                isEditing: _editEmail,
                onEditToggle: () => setState(() => _editEmail = !_editEmail),
              ),
              _buildEditableField(
                label: "Mot de passe",
                controller: _passwordController,
                isEditing: _editPassword,
                obscureText: true,
                onEditToggle: () => setState(() => _editPassword = !_editPassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEditToggle,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: isEditing
                ? TextField(
              controller: controller,
              obscureText: obscureText,
              cursorColor: Colors.blue,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: label,
                hintStyle: const TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade200),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            )
                : Text(
              "$label : ${controller.text}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.white),
            onPressed: onEditToggle,
          ),
        ],
      ),
    );
  }




  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildDarkModeDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Row(
              children: const [
                Icon(Icons.dark_mode, color: Colors.white),
                SizedBox(width: 12),
                Text('Mode sombre', style: TextStyle(color: Colors.white)),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Activer le mode sombre",
                      style: TextStyle(color: Colors.white),
                    ),
                    Switch(
                      value: _isDarkMode,
                      onChanged: (val) {
                        setState(() {
                          _isDarkMode = val;
                          // 👉 Ajoute ici ta logique pour changer le thème global
                        });
                      },
                      activeColor: Colors.blue[50],
                      inactiveThumbColor:bleu,
                      inactiveTrackColor: Colors.white24,
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


