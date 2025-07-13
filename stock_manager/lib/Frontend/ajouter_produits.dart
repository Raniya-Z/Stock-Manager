import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AjouterProduitPage extends StatefulWidget {
  final List<String> initialCategories;

  const AjouterProduitPage({super.key, required this.initialCategories});

  @override
  State<AjouterProduitPage> createState() => _AjouterProduitPageState();
}

class _AjouterProduitPageState extends State<AjouterProduitPage> {
  final Color bleu = const Color(0xFF0A1F56);
  final Color fond = const Color(0xFFFAFAFA);

  late List<String> categories;
  String? selectedCategorie;

  final TextEditingController nomProduitController = TextEditingController();
  final TextEditingController quantiteController = TextEditingController();
  final TextEditingController codeBarreController = TextEditingController();
  final TextEditingController prixAchatController = TextEditingController();
  final TextEditingController prixVenteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;

  int descriptionLimit = 1000;
  bool showLimitEditor = false;
  TextEditingController limitEditorController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    categories = List<String>.from(widget.initialCategories);
    if (!categories.contains('Autre')) {
      categories.add('Autre');
    }
  }

  void _ajouterNouvelleCategorie() {
    TextEditingController nouvelleCatController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bleu,
          title: Text(  "Entrer le nom de la nouvelle catégorie :",style:
          TextStyle(color: fond,fontSize: 20), textAlign: TextAlign.center,),
          content: TextField(
            controller: nouvelleCatController,
            style: const TextStyle(color: Colors.white,fontSize: 13),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: "Nom de la catégorie",
              hintStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context),
                child: const Text("Annuler", style: TextStyle(color: Colors.white,fontSize: 15))),
            TextButton(
              onPressed: () {
                final nom = nouvelleCatController.text.trim();
                if (nom.isNotEmpty) {
                  setState(() {
                    categories.insert(categories.length - 1, nom);
                    selectedCategorie = nom;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("OK", style: TextStyle(color: Colors.white,fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _choisirDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: bleu,
              surface: fond,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget champTexteMinimal(String label, TextEditingController controller, {Widget? suffix}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, right: 8),
        child: TextField(
          controller: controller,
          cursorColor: bleu,
          style: TextStyle(color: bleu),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
            suffixIcon: suffix,
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: bleu)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fond,
      appBar: AppBar(
        backgroundColor: bleu,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: fond),
            onPressed: () => Navigator.pop(context)),
        title: Text("Ajouter un nouveau produit",
            style: TextStyle(color: fond, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: bleu, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,

          ),



          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CATEGORIE
              const SizedBox(height: 13),
              Container(
        height: 40,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: bleu, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(

                  child: DropdownButton<String>(

                    value: selectedCategorie,
                    hint: Text("Catégories", style: TextStyle(color: bleu,fontSize: 14)),
                    isExpanded: true,
                    items: categories.map((cat) => DropdownMenuItem(value: cat,
                        child: Text(cat, style: TextStyle(color: bleu)))).toList(),
                    onChanged: (value) {
                      if (value == "Autre") {
                        _ajouterNouvelleCategorie();
                      } else {
                        setState(() => selectedCategorie = value);
                      }
                    },
                  ),
                ),
              ),
SizedBox(height: 13,),
              Row(children: [
                champTexteMinimal("Nom du produit", nomProduitController),
                champTexteMinimal(
                  "Code-barres",
                  codeBarreController,
                  suffix: Icon(Icons.qr_code_scanner, color: bleu),
                ),
              ]),
              SizedBox(height: 13),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end, // ✅ pour aligner verticalement en bas
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantiteController,
                      cursorColor: bleu,
                      style: TextStyle(color: bleu),
                      decoration: InputDecoration(
                        labelText: "Quantité",
                        labelStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: bleu),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      onTap: _choisirDate,
                      controller: TextEditingController(
                        text: selectedDate == null
                            ? ''
                            : DateFormat('dd/MM/yyyy').format(selectedDate!),
                      ),
                      cursorColor: bleu,
                      style: TextStyle(color: bleu),
                      decoration: InputDecoration(
                        labelText: "Date d'entrée",
                        labelStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.edit, color: Colors.grey),
                          onPressed: _choisirDate,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: bleu),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26,),

              Row(children: [
                champTexteMinimal("Prix d'achat", prixAchatController),
                champTexteMinimal("Prix de vente", prixVenteController),
              ]),

              const SizedBox(height: 26),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    flex: 2,
                    child: GestureDetector(

                      child: TextField(

                        controller: descriptionController,
                        cursorColor: bleu,
                        maxLength: 2000,
                        maxLines: 4,
                        decoration: InputDecoration(

                          hintText: "Description: Écrivez votre description...",
                          hintStyle: TextStyle(color: Colors.grey[500],fontSize: 13),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: bleu, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: bleu, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(color: bleu),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // PHOTO (à droite)
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: bleu, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: _image == null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, color: bleu, size: 40),
                            const SizedBox(height: 8),
                            Text("Ajouter une photo", style: TextStyle(color: bleu,fontSize: 13),),
                          ],
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              Row(

                children: [
                  // Bouton Rétablir



                  // Bouton Ajouter
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bleu,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        // TODO: Ajouter le produit à la base
                      },
                      child: const Text("Ajouter", style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: bleu, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          nomProduitController.clear();
                          codeBarreController.clear();
                          quantiteController.clear();
                          prixAchatController.clear();
                          prixVenteController.clear();
                          descriptionController.clear();
                          selectedDate = null;
                          selectedCategorie = null;
                          _image = null;
                        });
                      },
                      child: Text("Rétablir", style: TextStyle(fontSize: 15, color: bleu)),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 13),
            ],
          ),
        ),
      ),
    );
  }
}






/*// ... les imports
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AjouterProduitPage extends StatefulWidget {
  final List<String> initialCategories;

  const AjouterProduitPage({super.key, required this.initialCategories});

  @override
  State<AjouterProduitPage> createState() => _AjouterProduitPageState();
}

class _AjouterProduitPageState extends State<AjouterProduitPage> {
  final Color bleu = const Color(0xFF0A1F56);
  final Color fond = const Color(0xFFFAFAFA);

  late List<String> categories;
  String? selectedCategorie;

  final TextEditingController nomProduitController = TextEditingController();
  final TextEditingController quantiteController = TextEditingController();
  final TextEditingController codeBarreController = TextEditingController();
  final TextEditingController prixAchatController = TextEditingController();
  final TextEditingController prixVenteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    categories = List<String>.from(widget.initialCategories);
    if (!categories.contains('Autre')) {
      categories.add('Autre');
    }
  }

  void _ajouterNouvelleCategorie() {
    TextEditingController nouvelleCatController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bleu,
          title: const Text(
            "Entrer le nom de la nouvelle catégorie :",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: nouvelleCatController,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: "Nom de la catégorie",
              hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler", style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
            TextButton(
              onPressed: () {
                final nom = nouvelleCatController.text.trim();
                if (nom.isNotEmpty) {
                  setState(() {
                    categories.insert(categories.length - 1, nom);
                    selectedCategorie = nom;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("OK", style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _choisirDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('fr'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: bleu, surface: fond),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _scannerCodeBarre() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text("Scanner le code-barres"), backgroundColor: bleu),
          body: MobileScanner(
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              setState(() {
                codeBarreController.text = barcode.rawValue ?? '';
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget champTexteMinimal(String label, TextEditingController controller, {Widget? suffix}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, right: 8),
        child: TextField(
          controller: controller,
          cursorColor: bleu,
          style: TextStyle(color: bleu),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
            suffixIcon: suffix,
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: bleu)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fond,
      appBar: AppBar(
        backgroundColor: bleu,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: fond), onPressed: () => Navigator.pop(context)),
        title: Text("Ajouter un nouveau produit", style: TextStyle(color: fond, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: bleu, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Catégorie
              SizedBox(
                height: 50,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: bleu, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategorie,
                      hint: Text("Catégorie", style: TextStyle(color: bleu)),
                      isExpanded: true,
                      items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: TextStyle(color: bleu)))).toList(),
                      onChanged: (value) {
                        if (value == "Autre") {
                          _ajouterNouvelleCategorie();
                        } else {
                          setState(() => selectedCategorie = value);
                        }
                      },
                    ),
                  ),
                ),
              ),
              // Nom + Quantité
              Row(children: [
                champTexteMinimal("Nom du produit", nomProduitController),
                champTexteMinimal("Quantité", quantiteController),
              ]),
              // Code-barres + Date
              Row(children: [
                /*champTexteMinimal("Code-barres", codeBarreController,
                    suffix: IconButton(icon: Icon(Icons.qr_code_scanner, color: bleu),
                        onPressed: _scannerCodeBarre)),*/
                Expanded(
                  child: GestureDetector(
                    onTap: _choisirDate,
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 12, right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: bleu, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedDate == null ? "Date d'ajout" : "Date : ${DateFormat('dd/MM/yyyy', 'fr').format(selectedDate!)}",
                          style: TextStyle(color: bleu),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              // Prix
              Row(children: [
                champTexteMinimal("Prix d'achat", prixAchatController),
                champTexteMinimal("Prix de vente", prixVenteController),
              ]),
              const SizedBox(height: 12),
              // Description
              champTexteMinimal("Description", descriptionController),
              const SizedBox(height: 12),
              // Photo
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: bleu, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: _image == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, color: bleu, size: 30),
                      const SizedBox(height: 4),
                      Text("Photo", style: TextStyle(color: bleu, fontSize: 13)),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_image!, fit: BoxFit.cover, width: 120, height: 120),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: bleu,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // TODO: Ajouter le produit à la base
                },
                child: const Text("Ajouter", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/