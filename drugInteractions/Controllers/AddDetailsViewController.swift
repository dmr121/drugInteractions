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
    var drug = ""
    let usersCollection = Firestore.firestore().collection(K.Collections.usersCollection)
    let pharmacyCollection = Firestore.firestore().collection(K.Collections.pharmacyCollection)
    
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
        drugNameLabel.text = drug
    }
    
    //MARK: Functions
    func alertUserOfInvalidInput(_ message: String) {
        let alertController = UIAlertController(title: "Add To 💊Pharmkit", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let dosage = dosageTextField.text, let numDoses = numDosesTextField.text, let specialIn = specialInstructionsTextField.text {
            var data: [String: Any] = [
                "drugName": drug,
                "specialInstructions": specialIn
            ]
            // Needs refactored
            //MARK: Ugly Code
            if let dosageFloat = Float(dosage) {
                if dosageFloat > 0 {
                    data["dosage"] = dosageFloat
                } else {
                    alertUserOfInvalidInput("Dosage must be greater than 0.")
                    return
                }
            } else {
                alertUserOfInvalidInput("Dosage must be a number.")
                return
            }
            if let numDosesFloat = Float(numDoses) {
                if numDosesFloat > 0 {
                    data["numDoses"] = numDosesFloat
                } else {
                    alertUserOfInvalidInput("Number of Doses must be greater than 0.")
                    return
                }
            } else {
                alertUserOfInvalidInput("Number of Doses must be a number.")
                return
            }
            
            
            usersCollection.document((Auth.auth().currentUser?.email!)!).collection("currentPrescriptions").addDocument(data: data) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Added to Firebase")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}

extension AddDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
            /*
        case dosageTextField.tag:
            numDosesTextField.becomeFirstResponder()
            break
        case numDosesTextField.tag:
            specialInstructionsTextField.becomeFirstResponder()
            break
             */
        case specialInstructionsTextField.tag:
            specialInstructionsTextField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
}
