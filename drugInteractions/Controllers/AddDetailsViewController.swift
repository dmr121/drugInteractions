//
//  AddDetailsViewController.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/19/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

import UIKit
import Firebase

class AddDetailsViewController: UIViewController {
    
    //MARK: Variables
    var drugName = ""
    let db = Firestore.firestore().collection(K.Collections.usersCollection)
    
    //MARK: Outlets
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    
        //MARK: Text Fields
        @IBOutlet weak var dosageTextField: UITextField!
        @IBOutlet weak var numDosesTextField: UITextField!
        @IBOutlet weak var specialInstructionsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assigning delegation
        dosageTextField.delegate = self
        numDosesTextField.delegate = self
        specialInstructionsTextField.delegate = self
        
        addButton.layer.cornerRadius = 10
        dosageTextField.becomeFirstResponder()
        drugNameLabel.text = drugName
    }
    
    //MARK: Functions
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let dosage = dosageTextField.text, let numDoses = numDosesTextField.text, let specialIn = specialInstructionsTextField.text {
            let data = [
                "dosage": dosage,
                "numDoses": numDoses,
                "instructions": specialIn
            ]
            db.document((Auth.auth().currentUser?.email!)!).collection("currentPrescriptions").addDocument(data: data) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}

extension AddDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case dosageTextField.tag:
            numDosesTextField.becomeFirstResponder()
            break
        case numDosesTextField.tag:
            specialInstructionsTextField.becomeFirstResponder()
            break
        case specialInstructionsTextField.tag:
            specialInstructionsTextField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
}
