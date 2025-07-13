import 'package:flutter/material.dart';

class CategoriesProduits extends StatelessWidget {
  final String nomCategorie;

  const CategoriesProduits({super.key, required this.nomCategorie});

  @override
  Widget build(BuildContext context) {
    final Color bleu = const Color(0xFF0A1F56);
    final Color fond = const Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: fond,
      appBar: AppBar(
        backgroundColor: bleu,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: fond),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Catégorie : $nomCategorie",
          style:  TextStyle(color: fond, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: fond),
            onPressed: () {
              // à compléter pour ajouter un produit
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 35,color: Colors.grey[600]),
            SizedBox(height: 12),
            Text(
              "Aucun produit trouvé. Appuyez sur le bouton + pour en ajouter un.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600],fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
