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
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.UserPrescriptionCell, bundle: nil), forCellReuseIdentifier: K.reusableUserPrescriptionCell)
        addButton.layer.cornerRadius = 10
        checkInteractionsButton.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPrescriptions()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.PrescriptionToInfo {
            if let nextViewController = segue.destination as? InfoViewController {
                // Sending the proper drug information to the next view controller
                nextViewController.prescription = prescriptions[selectedRow!]
            }
        }
    }
    
    //MARK: Functions
    func loadPrescriptions() {
        prescriptions.removeAll() // Empty prescriptions array in case anything may have been in it
        
        usersCollection.document((Auth.auth().currentUser?.email!)!).collection("currentPrescriptions").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let data = doc.data()
                        let userPrescription = UserPrescription(data)
                        self.prescriptions.append(userPrescription)
                    }
                    
                    DispatchQueue.main.async {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableUserPrescriptionCell, for: indexPath) as! UserPrescriptionCell
        // Split the drug title on the paranthesis
        let drugTitle = prescriptions[indexPath.row].drugName.split(separator: "(", maxSplits: 1, omittingEmptySubsequences: false)
        // Take first part of drug title (this is the simple name)
        let drugName = String(drugTitle[0])
        cell.drugNameLabel.text = drugName
        // Hide the subtitle in case we don't use it
        cell.alternateNamesLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // If there is more than one element in the splitted string array
        // set the drug suggestion cell subtitle to that second element
        if drugTitle.count > 1 {
            // Make sure to remove the last paranthesis in the subtitle with
            // the following prefix method
            let alternateNames = String(drugTitle[1].prefix(drugTitle[1].count - 1))
            // Un-hide the subtitle
            cell.alternateNamesLabel.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            // Set the subtitle in the cell to the found subtitle
            cell.alternateNamesLabel.text = alternateNames
        }
        
        let dosage = prescriptions[indexPath.row].dosage
        let numDoses = prescriptions[indexPath.row].numDoses
        
        cell.dosageLabel.text = String(dosage) + " mg"
        cell.numDosesLabel.text = String(Int(numDoses)) + " daily"
        
        return cell
    }
}

extension PrescriptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: K.Segues.PrescriptionToInfo, sender: self)
    }
}
