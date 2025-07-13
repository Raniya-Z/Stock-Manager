import 'package:flutter/material.dart';

class HistoriqueStockPage extends StatefulWidget {
  const HistoriqueStockPage({super.key});

  @override
  State<HistoriqueStockPage> createState() => _HistoriqueStockPageState();
}

class _HistoriqueStockPageState extends State<HistoriqueStockPage> {
  final Color bleu = const Color(0xFF0A1F56);
  final Color fond = const Color(0xFFFAFAFA);

  Map<String, List<Map<String, String>>> historiqueParMois = {
    "juin 2025": [
      {"action": "ajout", "produit": "Écran Dell", "categorie": "Moniteurs", "date": "20/06/2025"},
      {"action": "entree", "produit": "Tablette Lenovo", "categorie": "Tablettes", "date": "18/06/2025"},
      {"action": "modification", "produit": "Clé USB", "categorie": "Stockage", "date": "15/06/2025"},
      {"action": "suppression", "produit": "Souris Logitech", "categorie": "Accessoires", "date": "13/06/2025"},
      {"action": "sortie", "produit": "Câble VGA", "categorie": "Accessoires", "date": "11/06/2025"},
      {"action": "nouvelle_categorie", "categorie": "Serveurs", "date": "09/06/2025"},
    ],
    "mai 2025": [
      {"action": "ajout", "produit": "Routeur TP-Link", "categorie": "Réseau", "date": "28/05/2025"},
      {"action": "sortie", "produit": "Câble HDMI", "categorie": "Accessoires", "date": "25/05/2025"},
      {"action": "modification", "produit": "Webcam Logitech", "categorie": "Périphériques", "date": "22/05/2025"},
      {"action": "suppression", "produit": "Casque Sony", "categorie": "Audio", "date": "20/05/2025"},
      {"action": "entree", "produit": "Imprimante HP", "categorie": "Imprimantes", "date": "17/05/2025"},
      {"action": "nouvelle_categorie", "categorie": "Smartphones", "date": "15/05/2025"},
    ],
    "avril 2025": [
      {"action": "ajout", "produit": "Disque SSD", "categorie": "Stockage", "date": "30/04/2025"},
      {"action": "sortie", "produit": "Clavier AZERTY", "categorie": "Accessoires", "date": "27/04/2025"},
      {"action": "modification", "produit": "Écran Samsung", "categorie": "Moniteurs", "date": "24/04/2025"},
      {"action": "suppression", "produit": "Chargeur USB-C", "categorie": "Accessoires", "date": "20/04/2025"},
      {"action": "entree", "produit": "Switch Netgear", "categorie": "Réseau", "date": "17/04/2025"},
      {"action": "nouvelle_categorie", "categorie": "Objets connectés", "date": "15/04/2025"},
    ],
  };


  Set<Map<String, String>> elementsSelectionnes = {};

  Icon getActionIcon(String action) {
    switch (action) {
      case 'ajout':
        return Icon(  Icons.add_box_outlined, color: bleu, size: 25);
      case 'modification':
        return Icon(Icons.edit, color: bleu, size: 25);
      case 'suppression':
        return Icon(Icons.delete, color: bleu, size: 25);
      case 'entree':
        return Icon(Icons.input_outlined, color: bleu, size: 25);
      case 'sortie':
        return Icon( Icons.output_outlined, color: bleu, size: 25);
      case 'nouvelle_categorie':
        return Icon(Icons.category, color: bleu, size: 25);
      default:
        return Icon(Icons.info, color: bleu, size: 25);
    }
  }

  String getActionDescription(Map<String, String> item) {
    String action = item['action'] ?? '';
    switch (action) {
      case 'ajout':
        return "Ajout du produit ${item['produit']} dans la catégorie ${item['categorie']}";
      case 'modification':
        return "Modification du produit ${item['produit']} dans la catégorie ${item['categorie']}";
      case 'suppression':
        return "Suppression du produit ${item['produit']} dans la catégorie ${item['categorie']}";
      case 'entree':
        return "Entrée de stock pour ${item['produit']} dans la catégorie ${item['categorie']}";
      case 'sortie':
        return "Sortie de stock pour ${item['produit']} dans la catégorie ${item['categorie']}";
      case 'nouvelle_categorie':
        return "Ajout d'une nouvelle catégorie : ${item['categorie']}";
      default:
        return "Action inconnue";
    }
  }

  void supprimerSelection() {
    setState(() {
      for (var mois in historiqueParMois.keys.toList()) {
        historiqueParMois[mois]!.removeWhere((item) => elementsSelectionnes.contains(item));
        if (historiqueParMois[mois]!.isEmpty) {
          historiqueParMois.remove(mois);
        }
      }
      elementsSelectionnes.clear();
    });
  }

  bool estSelectionne(Map<String, String> item) {
    return elementsSelectionnes.contains(item);
  }

  void toggleSelection(Map<String, String> item) {
    setState(() {
      if (estSelectionne(item)) {
        elementsSelectionnes.remove(item);
      } else {
        elementsSelectionnes.add(item);
      }
    });
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
          elementsSelectionnes.isEmpty
              ? "Historique de stock"
              : "${elementsSelectionnes.length} sélectionné(s)",
          style: TextStyle(color: fond, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          if (elementsSelectionnes.isNotEmpty) ...[
            TextButton.icon(
              icon: Icon(
                elementsSelectionnes.length ==
                    historiqueParMois.values.fold(0, (sum, list) => sum + list.length)
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank_outlined,
                color: fond,
              ),
              label: Text("Tout", style: TextStyle(color: fond)),
              onPressed: () {
                setState(() {
                  int totalElements = historiqueParMois.values.fold(0, (sum, list) => sum + list.length);
                  if (elementsSelectionnes.length == totalElements) {
                    elementsSelectionnes.clear(); // Tout décocher
                  } else {
                    elementsSelectionnes.clear();
                    for (var liste in historiqueParMois.values) {
                      elementsSelectionnes.addAll(liste); // Tout cocher
                    }
                  }
                });
              },
            ),


            IconButton(
              icon: Icon(Icons.delete, color: fond),
              onPressed: supprimerSelection,
            ),
          ]
        ],


      ),
      body: historiqueParMois.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 35, color: Colors.grey[600]),
            const SizedBox(height: 10),
            Text("Aucun historique disponible",
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: historiqueParMois.entries.map((entry) {
            final mois = entry.key;
            final actions = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Historique $mois",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...actions.map((item) {
                  return GestureDetector(
                    onLongPress: () => toggleSelection(item),
                    onTap: () {
                      if (elementsSelectionnes.isNotEmpty) {
                        toggleSelection(item);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: estSelectionne(item)
                            ? Colors.blue[50]
                            : Colors.white,
                        border: Border.all(color: bleu, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(item['date'] ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10)),
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    getActionIcon(item['action'] ?? ''),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        getActionDescription(item),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
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
                }).toList(),
                const SizedBox(height: 24),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
