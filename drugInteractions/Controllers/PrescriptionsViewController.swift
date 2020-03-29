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
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var prescriptions: [UserPrescription] = []
    let usersCollection = Firestore.firestore().collection(K.Collections.usersCollection)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        addButton.layer.cornerRadius = 10
        checkInteractionsButton.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPrescriptions()
    }
    
    //MARK: Functions
    func loadPrescriptions() {
        prescriptions.removeAll() // Empty prescriptions array in case anything may have been in it
        
        usersCollection.document((Auth.auth().currentUser?.email!)!).collection("currentPrescriptions").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    print("HERE 1")
                    print("There are \(documents.count) documents")
                    for doc in documents {
                        print("HERE 2")
                        let data = doc.data()
                        let userPrescription = UserPrescription(data)
                        self.prescriptions.append(userPrescription)
                    }
                    
                    DispatchQueue.main.async {
                        print("HERE 3")
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: Actions
    @IBAction func logoutBarButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension PrescriptionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return prescriptions.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableUserPrescriptionCell, for: indexPath)
        cell.textLabel?.text = prescriptions[indexPath.row].drugName
        print(prescriptions[indexPath.row].drugName)
        return cell
    }
}
