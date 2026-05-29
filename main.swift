// =====================================================
// PROJET FINAL SWIFT - 8 JANVIER 2026                 |
// MEMBRES DU GROUPE :                                 |
//      - CHERY Guivens                                |    
//      - CHARLES Youvens                              |               
//      - TIMOTHEE Romane Calojelo                     |     
// =====================================================


import Foundation

// =====================================================
// ENUM : TYPE D'ALIMENTATION
// =====================================================

enum TypeAlimentation: String, CaseIterable {
    case allaitement = "Allaitement maternel"
    case artificiel = "Lait artificiel"
    case mixte = "Mixte"
}

// =====================================================
// STRUCT : SUIVI JOURNALIER
// =====================================================

struct SuiviJournalier {
    let jour: Int                    
    let poids: Double               
    let temperature: Double        
    let alimentation: TypeAlimentation
    let repas: Int                  
}

// =====================================================
// CLASS : GESTION DU SUIVI MÉDICAL
// =====================================================

class SuiviMedical {

    // Historique des suivis journaliers
    private(set) var historique: [SuiviJournalier] = []

    // Ajoute un nouveau suivi journalier
    func ajouterSuivi(_ suivi: SuiviJournalier) {
        historique.append(suivi)
    }

    // Calcule l'évolution totale du poids
    func evolutionTotalePoids() -> Double {
        guard let first = historique.first,
              let last = historique.last else { return 0 }
        return last.poids - first.poids
    }

    // Calcule la température moyenne
    func moyenneTemperature() -> Double {
        guard !historique.isEmpty else { return 0 }
        let total = historique.reduce(0.0) { $0 + $1.temperature }
        return total / Double(historique.count)
    }

    // Calcule le nombre total de repas
    func totalRepas() -> Int {
        return historique.reduce(0) { $0 + $1.repas }
    }

    // Calcule la moyenne de repas par jour
    func moyenneRepasParJour() -> Double {
        guard !historique.isEmpty else { return 0 }
        return Double(totalRepas()) / Double(historique.count)
    }

    // Centre le texte dans une largeur donnée
    func centerText(_ texte: String, width: Int) -> String {
        if texte.count >= width { return texte }
        let spaces = (width - texte.count) / 2
        return String(repeating: " ", count: spaces) + texte
    }


    // Affiche un tableau médical structuré et lisible
    func afficherTableau() {
        print("\n--- HISTORIQUE DU SUIVI MÉDICAL ---")

        if historique.isEmpty {
            print("Aucune donnée enregistrée.")
            return
        }

        print("+------+-----------+-----------+----------------------+--------+")
        print("| Jour | Poids (kg)| Temp (°C) | Alimentation         | Repas  |")
        print("+------+-----------+-----------+----------------------+--------+")

        for s in historique {
            let jour = String(format: "%-4d", s.jour)
            let poids = String(format: "%-9.3f", s.poids)
            let temp = String(format: "%-9.1f", s.temperature)
            let alim = String(format: "%-20s", (s.alimentation.rawValue as NSString).utf8String!)
            let repas = String(format: "%-6d", s.repas)

            print("| \(jour) | \(poids) | \(temp) | \(alim) | \(repas) |")
        }

        print("+------+-----------+-----------+----------------------+--------+")
    }

    // Affiche le récapitulatif médical formaté
   func afficherRecapitulatif() {
        guard historique.count >= 1 else {
            print("Aucune donnée disponible.")
            return
        }

        let largeur = 55
        let ligne = "+" + String(repeating: "-", count: largeur - 2) + "+"

        func printLine(_ texte: String = "") {
            let contenu = texte.padding(toLength: largeur - 4, withPad: " ", startingAt: 0)
            print("| \(contenu) |")
        }

        let first = historique.first!
        let last = historique.last!

        print("\n" + ligne)
        printLine(centerText("RÉCAPITULATIF MÉDICAL", width: largeur - 4))
        print(ligne)

        printLine("Poids initial        : \(String(format: "%.3f", first.poids)) kg")
        printLine("Poids actuel         : \(String(format: "%.3f", last.poids)) kg")
        printLine("Évolution totale     : \(String(format: "%.3f", evolutionTotalePoids())) kg")
        printLine("Température moyenne  : \(String(format: "%.1f", moyenneTemperature())) °C")
        printLine("Total repas          : \(totalRepas())")
        printLine("Moyenne repas/jour   : \(String(format: "%.2f", moyenneRepasParJour()))")

        print(ligne)
        printLine("STATUT DU POIDS      : \(statutPoids())")
        printLine("STATUT TEMPÉRATURE   : \(statutTemperature())")
        print(ligne + "\n")
    }




    
    // Évaluation médicale du poids
    func statutPoids() -> String {
        guard historique.count >= 2 else {
            return "Données insuffisantes"
        }

        let evolution = evolutionTotalePoids()

        if evolution < 0 {
            return "Sous-poids (perte de poids)"
        } else if evolution <= 1.5 {
            return "Poids normal"
        } else {
            return "Surpoids (prise rapide)"
        }
    }

    // Évaluation médicale de la température moyenne
    func statutTemperature() -> String {
        let moyenne = moyenneTemperature()

        if moyenne < 36.5 {
            return "Hypothermie"
        } else if moyenne <= 37.5 {
            return "Température normale"
        } else {
            return "Fièvre"
        }
    }
}

// =====================================================
// FONCTIONS DE VALIDATION DES SAISIES
// =====================================================

func lireDoubleSecurise(prompt: String, min: Double, max: Double) -> Double {
    while true {
        print(prompt, terminator: " ")
        guard let input = readLine()?.trimmingCharacters(in: .whitespaces),
              !input.isEmpty else {
            print("Erreur : Champ vide.")
            continue
        }

        let formatted = input.replacingOccurrences(of: ",", with: ".")
        if let valeur = Double(formatted), valeur >= min, valeur <= max {
            return valeur
        } else {
            print("Erreur : Valeur invalide ou hors limites (\(min) - \(max)).")
        }
    }
}

func lireIntSecurise(prompt: String, min: Int, max: Int) -> Int {
    while true {
        print(prompt, terminator: " ")
        guard let input = readLine(),
              let valeur = Int(input),
              valeur >= min, valeur <= max else {
            print("Erreur : Entrez un entier valide (\(min) - \(max)).")
            continue
        }
        return valeur
    }
}

// Sélection sécurisée du type d’alimentation
func lireAlimentation() -> TypeAlimentation {
    print("\nType d'alimentation :")
    for (i, t) in TypeAlimentation.allCases.enumerated() {
        print("\(i + 1). \(t.rawValue)")
    }

    let choix = lireIntSecurise(
        prompt: "\nVotre choix :",
        min: 1,
        max: TypeAlimentation.allCases.count
    )

    return TypeAlimentation.allCases[choix - 1]
}


// =====================================================
// PROGRAMME PRINCIPAL
// =====================================================

print("===================================================")
print(" HÔPITAL SERVING SANTÉ DU HAUT-LIMBÉ")
print(" SERVICE DE PÉDIATRIE - SUIVI DU NOUVEAU-NÉ")
print("===================================================")

let suivi = SuiviMedical()
var continuer = true

while continuer {
    print("\n--- MENU PRINCIPAL ---")
    print("1. Enregistrer les données")
    print("2. Afficher le suivi médical")
    print("3. Quitter")

    let choix = readLine() ?? ""

    switch choix {
    case "1":
        let jour = suivi.historique.count + 1
        print("\n--- SAISIE JOUR \(jour) ---")

        let poids = lireDoubleSecurise(prompt: "\nPoids(kg), (1.5 - 10) :", min: 1.5, max: 10.0)
        let temp = lireDoubleSecurise(prompt: "\nTempérature(°C), (34 - 43) :", min: 34.0, max: 43.0)
        let alim = lireAlimentation()
        let repas = lireIntSecurise(prompt: "\nNombre de repas, (1 - 15) :", min: 1, max: 15)

        let suiviJour = SuiviJournalier(
            jour: jour,
            poids: poids,
            temperature: temp,
            alimentation: alim,
            repas: repas
        )

        suivi.ajouterSuivi(suiviJour)
        print("Données enregistrées avec succès.")

    case "2":
        if suivi.historique.isEmpty {
            print("Aucun suivi enregistré.")
        } else {
            suivi.afficherTableau()

            suivi.afficherRecapitulatif()

        }

    case "3":
        print("Fermeture du système. Au revoir !")
        continuer = false

    default:
        print("Choix invalide.")
    }
}
