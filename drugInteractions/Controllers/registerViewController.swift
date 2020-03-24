//
//  registerViewController.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/3/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

import UIKit
import Firebase

class registerViewController: UIViewController, UITextFieldDelegate {

    //MARK: Variables
    let usersDB = Firestore.firestore().collection(K.Collections.usersCollection)
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        signUpButton.layer.cornerRadius = 10
        emailTextField.becomeFirstResponder()
    }
    
    //MARK: Functions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        signUp()
    }
    
    func signUp() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
                if let error = error {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = error.localizedDescription
                } else {
                    self.addNewUser(email)
                }
            }
        }
    }
    
    // When the return key on the keyboard is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField.tag) {
        case emailTextField.tag:
            // Return key on email field will jump to password field
            // Prevents user from having to click next field
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField.tag:
            signUp()
            break
        default:
            break
        }
        return true
    }
    
    // Adds new user to the "users" database
    func addNewUser(_ email: String) {
        usersDB.addDocument(data: ["email": email]) { (error) in
            if let error = error {
                self.errorMessageLabel.isHidden = false
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                self.passwordTextField.resignFirstResponder()
                self.performSegue(withIdentifier: K.Segues.RegisterToPrescriptions, sender: self)
            }
        }
    }
}
