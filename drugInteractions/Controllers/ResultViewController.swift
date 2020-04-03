//
//  ResultViewController.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 4/2/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

import Foundation
import Firebase

class ResultViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var interactionDescriptionLabel: UILabel!
    
    //MARK: Variables
    var drugName = ""
    var drugTitle = ""
    let pharmCollection = Firestore.firestore().collection(K.Collections.pharmacyCollection)
    var prescriptions: [UserPrescription] = []
    let severityColors: [Int: UIColor] = [
        0: .systemGreen,
        1: .systemYellow,
        2: .systemOrange,
        3: .systemRed
    ]
    let severityDescriptions: [Int: String] = [
        0: "No reactions found between",
        1: "Mild reactions found between",
        2: "Moderate reactions found between",
        3: "Severe reactions found between"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Split the drug title on the paranthesis
        let drugTitle = drugName.split(separator: "(", maxSplits: 1, omittingEmptySubsequences: false)
        // Take first part of drug title (this is the simple name)
        drugName = String(drugTitle[0])
        
        checkInteractions()
    }
    
    //MARK: Functions
    func extractDrugNames(in drugName: String) -> [String] {
           var allDrugNamesAndAlternateNames: [String] = []
               let drugNames = drugName.drugNames()
               for name in drugNames {
                   if name != "" {
                       allDrugNamesAndAlternateNames.append(name.lowercased())
                   }
               }
           return allDrugNamesAndAlternateNames
       }
    
    func checkInteractions() {
        let drugsToCheck = extractDrugNames(in: drugName)
        var currentUserPrescriptions: [String] = []
        for script in prescriptions {
            currentUserPrescriptions.append(script.drugName)
        }
        var severity = 0
        pharmCollection.whereField("drugName", in: currentUserPrescriptions).getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let interactions = Drug(doc.data()).interactions
                        for interaction in interactions {
                            if drugsToCheck.contains(interaction.drugName.lowercased()) {
                                if interaction.severity > severity {
                                    severity = interaction.severity
                                }
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    let description = self.severityDescriptions[severity]! + " " + self.drugName + " and your prescriptions."
                    self.interactionDescriptionLabel.text = description
                    UIView.animate(withDuration: 2.0) {
                        self.view.backgroundColor = self.severityColors[severity]
                    }
                }
            }
        }
    }
}

extension String {
    func drugNames() -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: "([a-zA-Z])*")
            let string = self as NSString
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
            }
        } catch {
            return []
        }
    }
}
