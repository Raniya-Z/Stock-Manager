import 'package:flutter/material.dart';

import 'categories_produits.dart';

class ProduitsCategories extends StatefulWidget {
  const ProduitsCategories({super.key});

  @override
  State<ProduitsCategories> createState() => _ProduitsCategoriesState();
}

class _ProduitsCategoriesState extends State<ProduitsCategories> {
  final Color bleu = const Color(0xFF0A1F56);
  final Color fond = const Color(0xFFFAFAFA);

  final List<String> categories = [];
  final TextEditingController _controller = TextEditingController();

  void _ajouterCategorie() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bleu,
          title: const Text(
            "Entrer le nom de la nouvelle catégorie :",
            style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: _controller,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white,   fontSize: 13),
            decoration: const InputDecoration(
              hintText: "Nom de la catégorie",

              hintStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler", style: TextStyle(color: Colors.white,  fontSize: 15,)),
            ),
            TextButton(
              onPressed: () {
                final nom = _controller.text.trim();
                if (nom.isNotEmpty) {
                  setState(() {
                    categories.add(nom);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("OK", style: TextStyle(color: Colors.white,  fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  void _modifierOuSupprimer(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bleu,
          title: const Text(
            "Action sur la catégorie :",
            style: TextStyle(color: Colors.white70,    fontWeight: FontWeight.w600,fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _modifierCategorie(index);
                },
                child: const Text("Modifier", style: TextStyle(color: Colors.white,  fontSize: 14)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _confirmerSuppression(index);
                },
                child: const Text("Supprimer", style: TextStyle(color: Colors.white,  fontSize: 14)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmerSuppression(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bleu,
          title: const Text(
            "Confirmer la suppression",
            style: TextStyle(color: Colors.white,  fontWeight: FontWeight.w600, fontSize:20 ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "Êtes-vous sûr de vouloir supprimer cette catégorie ?",
            style: TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler", style: TextStyle(color: Colors.white,fontSize: 15)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  categories.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Supprimer", style: TextStyle(color: Colors.white,fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  void _modifierCategorie(int index) {
    _controller.text = categories[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bleu,
          title: const Text(
            "Modifier la catégorie :",
            style: TextStyle(color: Colors.white,  fontWeight: FontWeight.w600,fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: _controller,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white,fontSize: 13),
            decoration: const InputDecoration(
              hintText: "Nouveau nom",
              hintStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler", style: TextStyle(color: Colors.white,fontSize: 15)),
            ),
            TextButton(
              onPressed: () {
                final nom = _controller.text.trim();
                if (nom.isNotEmpty) {
                  setState(() {
                    categories[index] = nom;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("OK", style: TextStyle(color: Colors.white,fontSize: 15)),
            ),
          ],
        );
      },
    );
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
        title: Text(
          "Mes produits : Mes catégories",
          style: TextStyle(
            color: fond,
            fontWeight: FontWeight.w600,
            fontSize: 18, //20
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:  Icon(Icons.add, color: fond),
            onPressed: _ajouterCategorie,
          ),
        ],

      ),

      body: categories.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(Icons.category_outlined, size: 35, color: Colors.grey[600]),
            const SizedBox(height: 12),
            Text(
              "Liste vide. Ajoutez une catégorie avec le bouton +",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),

      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoriesProduits(
                    nomCategorie: categories[index],
                  ),
                ),
              );
            },

            onLongPress: () => _modifierOuSupprimer(index),
            child: Container(

              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(

                color: Colors.white,
                border: Border.all(color: bleu, width: 4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                categories[index],
                style: TextStyle(color: bleu, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }

}
