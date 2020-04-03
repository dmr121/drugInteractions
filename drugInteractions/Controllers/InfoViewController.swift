//
//  InfoViewController.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/30/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

import Foundation
import Firebase

class InfoViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var numDosesLabel: UILabel!
    @IBOutlet weak var specialInstructionsLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var specialInstructionsPermanentLabel: UILabel!
    
    //MARK: Variables
    var prescription = UserPrescription()
    let usersCollection = Firestore.firestore().collection(K.Collections.usersCollection)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drugNameLabel.text = prescription.drugName
        dosageLabel.text = String(prescription.dosage) + " mg"
        numDosesLabel.text = String(Int(prescription.numDoses)) + " per day"
        
        let specialIn = prescription.specialInstructions
        if specialIn != "" {
            specialInstructionsLabel.text = specialIn
        } else {
            specialInstructionsLabel.isHidden = true
            specialInstructionsPermanentLabel.text = "No Special Instructions"
        }
        removeButton.layer.cornerRadius = 10
    }
    
    //MARK: Actions
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        usersCollection.document((Auth.auth().currentUser?.email)!).collection(K.Collections.currentPrescriptionsCollection).document(prescription.id).delete { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
