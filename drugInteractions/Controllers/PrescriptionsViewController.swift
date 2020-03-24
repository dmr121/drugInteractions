//
//  PrescriptionsViewController.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/4/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

import UIKit
import Firebase

class PrescriptionsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var checkInteractionsButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        addButton.layer.cornerRadius = 10
        checkInteractionsButton.layer.cornerRadius = 10
    }
    
    //MARK: Functions
    @IBAction func logoutBarButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}
