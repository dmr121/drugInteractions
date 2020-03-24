//
//  loginViewController.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/2/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.layer.cornerRadius = 10
        emailTextField.becomeFirstResponder()
    }
    
    //MARK: Functions
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        logIn()
    }
    
    func logIn() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
                if let error = error {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = error.localizedDescription
                } else {
                    self.passwordTextField.resignFirstResponder()
                    self.performSegue(withIdentifier: K.Segues.LoginToPrescriptions, sender: self)
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
            logIn()
            break
        default:
            break
        }
        return true
    }
    
}
