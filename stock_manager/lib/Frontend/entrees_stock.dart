import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EntreesStockPage extends StatefulWidget {
  final List<String> initialCategories;
  final List<String> initialProduits;

  const EntreesStockPage({
    super.key,
    required this.initialCategories,
    required this.initialProduits,
  });

  @override
  State<EntreesStockPage> createState() => _EntreesStockPageState();
}

class _EntreesStockPageState extends State<EntreesStockPage> {
  final Color bleu = const Color(0xFF0A1F56);
  final Color fond = const Color(0xFFFAFAFA);

  late List<String> categories;
  String? selectedCategorie;
  late List<String> produits;
  String? selectedProduit;

  final TextEditingController quantiteDeStockController = TextEditingController(text: "");//text=""
  final TextEditingController quantiteAjouteeController = TextEditingController();
  final TextEditingController codeBarreController = TextEditingController();
  DateTime? selectedDate;


  @override
  void initState() {
    super.initState();
    categories = widget.initialCategories;
    produits = widget.initialProduits;
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fond,
      appBar: AppBar(
        backgroundColor: bleu,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: fond),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Entrées de stock",
            style: TextStyle(color: fond, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.add_circle_outline, color: fond),
          ),
        ],
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
              const SizedBox(height: 13),
              // Dropdown Catégorie
              Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: bleu, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCategorie,
                    hint: Text("Catégories", style: TextStyle(color: bleu, fontSize: 14)),
                    isExpanded: true,
                    items: categories.map((cat) => DropdownMenuItem(
                        value: cat, child: Text(cat, style: TextStyle(color: bleu)))).toList(),
                    onChanged: (value) {
                      setState(() => selectedCategorie = value);
                    },
                  ),
                ),
              ),
              // Dropdown Produit
              const SizedBox(height: 13),
              Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: bleu, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedProduit,
                    hint: Text("Produits", style: TextStyle(color: bleu, fontSize: 14)),
                    isExpanded: true,
                    items: produits.map((prod) => DropdownMenuItem(
                        value: prod, child: Text(prod, style: TextStyle(color: bleu)))).toList(),
                    onChanged: (value) {
                      setState(() => selectedProduit = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 13),
              // Quantité stock et Quantité entrée
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantiteDeStockController,
                      readOnly: true,
                      cursorColor: bleu,
                      style: TextStyle(color: bleu),
                      decoration: InputDecoration(
                        labelText: "Quantité en stock",
                        labelStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: bleu)),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: quantiteAjouteeController,
                      cursorColor: bleu,
                      style: TextStyle(color: bleu),
                      decoration: InputDecoration(
                        labelText: "Quantité entrée",
                        labelStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: bleu)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Date et Code-barres (cadres sans icône)
              Row(
                children: [
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
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: codeBarreController,
                      cursorColor: bleu,
                      style: TextStyle(color: bleu),
                      decoration: InputDecoration(
                        labelText: "Code-barres",
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
                ],
              ),

              const SizedBox(height:50),
              // Image Scan Placeholder
              Align(
                alignment: Alignment.center,  // ou start, end selon besoin
                child: SizedBox(
                  width: 180,
                  height: 150,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: bleu, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_scanner, color: bleu, size: 40),
                        SizedBox(height: 8),
                        Text("Scanner un produit", style: TextStyle(color: bleu, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 40),
              // Boutons
              Row(
                children: [
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
                      child: const Text("Valider", style: TextStyle(fontSize: 15, color: Colors.white)),
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
                          selectedCategorie = null;
                          selectedProduit = null;
                          quantiteAjouteeController.clear();
                          codeBarreController.clear();
                          selectedDate = null;

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
