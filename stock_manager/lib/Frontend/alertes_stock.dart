import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlertesStockPage extends StatefulWidget {
  @override
  _AlertesStockPageState createState() => _AlertesStockPageState();
}

class _AlertesStockPageState extends State<AlertesStockPage> {
  final Color bleu = const Color(0xFF0A1F56);
  final Color fond = const Color(0xFFFAFAFA);

  Map<String, List<Map<String, dynamic>>> alertesParMois = {
    "Juin 2025": [
      {"date": DateTime(2025, 6, 20), "produit": "Écran Dell", "quantite": 5},
      {"date": DateTime(2025, 6, 18), "produit": "Tablette Lenovo", "quantite": 9},
      {"date": DateTime(2025, 6, 15), "produit": "Clé USB", "quantite": 0},
      {"date": DateTime(2025, 6, 12), "produit": "Souris HP", "quantite": 12},
    ],
    "Mai 2025": [
      {"date": DateTime(2025, 5, 28), "produit": "Routeur TP-Link", "quantite": 3},
      {"date": DateTime(2025, 5, 25), "produit": "Câble HDMI", "quantite": 1},
      {"date": DateTime(2025, 5, 20), "produit": "Webcam Logitech", "quantite": 0},
      {"date": DateTime(2025, 5, 18), "produit": "Casque Sony", "quantite": 15},
    ],
    "Avril 2025": [
      {"date": DateTime(2025, 4, 10), "produit": "Disque SSD", "quantite": 10},
      {"date": DateTime(2025, 4, 5), "produit": "Smartphone Samsung", "quantite": 7},
      {"date": DateTime(2025, 4, 3), "produit": "Clavier Logitech", "quantite": 0},
      {"date": DateTime(2025, 4, 1), "produit": "Imprimante HP", "quantite": 4},
    ],
  };

  Set<Map<String, dynamic>> elementsSelectionnes = {};

  void supprimerSelection() {
    setState(() {
      for (var mois in alertesParMois.keys.toList()) {
        alertesParMois[mois]!.removeWhere((item) => elementsSelectionnes.contains(item));
        // Supprimer le mois si la liste est vide
        if (alertesParMois[mois]!.isEmpty) {
          alertesParMois.remove(mois);
        }
      }
      elementsSelectionnes.clear();
    });
  }

  Color getCouleurAlerte(int quantite) {
    if (quantite == 0) return Colors.red.shade400;        // Stock terminé
    if (quantite <= 5) return Colors.yellow.shade700;     // Stock faible
    if (quantite <= 10) return Colors.orange.shade700;    // Rupture de stock
    return Colors.green.shade600;                          // Stock dispo
  }

  String getTexteAlerte(int quantite) {
    if (quantite == 0) return "Stock terminé";
    if (quantite <= 5) return "Stock faible";
    if (quantite <= 10) return "Rupture de stock";
    return "Stock disponible";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fond,
      appBar: AppBar(
        backgroundColor: bleu,
        leading: elementsSelectionnes.isNotEmpty
            ? IconButton(
          icon: Icon(Icons.close, color: fond),
          onPressed: () {
            setState(() => elementsSelectionnes.clear());
          },
        )
            : IconButton(
          icon: Icon(Icons.arrow_back, color: fond),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          elementsSelectionnes.isNotEmpty
              ? "${elementsSelectionnes.length} sélectionné(s)"
              : "Alertes de stock",
          style: TextStyle(color: fond, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          if (elementsSelectionnes.isNotEmpty) ...[
            TextButton.icon(
              icon: Icon(
                elementsSelectionnes.length ==
                    alertesParMois.values.fold(0, (sum, list) => sum + list.length)
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank_outlined,
                color: fond,
              ),
              label: Text("Tout", style: TextStyle(color: fond)),
              onPressed: () {
                setState(() {
                  int totalElements =
                  alertesParMois.values.fold(0, (sum, list) => sum + list.length);
                  if (elementsSelectionnes.length == totalElements) {
                    elementsSelectionnes.clear(); // Tout décocher
                  } else {
                    elementsSelectionnes.clear();
                    for (var liste in alertesParMois.values) {
                      elementsSelectionnes.addAll(liste); // Tout cocher
                    }
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: fond),
              onPressed: supprimerSelection,
              tooltip: "Supprimer sélection",
            ),
          ],
          const SizedBox(width: 8),
          if (elementsSelectionnes.isEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.notification_important, color: fond),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: alertesParMois.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notification_important_outlined,
                  size: 35, color: Colors.grey[600]),
              const SizedBox(height: 20),
              Text(
                "Pas d'alertes de stock.\nTous les produits sont disponibles.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        )
            : ListView(
          children: alertesParMois.entries.map((entry) {
            final mois = entry.key;
            final alertes = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alertes $mois",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...alertes.map((item) {
                  final couleur = getCouleurAlerte(item['quantite'] as int);
                  final texteAlerte = getTexteAlerte(item['quantite'] as int);
                  final isSelected = elementsSelectionnes.contains(item);

                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        if (isSelected) {
                          elementsSelectionnes.remove(item);
                        } else {
                          elementsSelectionnes.add(item);
                        }
                      });
                    },
                    onTap: () {
                      if (elementsSelectionnes.isNotEmpty) {
                        setState(() {
                          if (isSelected) {
                            elementsSelectionnes.remove(item);
                          } else {
                            elementsSelectionnes.add(item);
                          }
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: couleur.withOpacity(0.15),
                        border: Border.all(color: couleur, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: couleur.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          )
                        ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(item['date'] as DateTime),
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "$texteAlerte : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: couleur,
                                    ),
                                  ),
                                  TextSpan(
                                    text: item['produit'],
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "${item['quantite']}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: couleur,
                              ),
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
