//
//  CheckViewController.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/30/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

import Foundation
import Firebase

class CheckViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: Variables
    var prescriptions: [UserPrescription] = []
    var selectedRow: Int?
    var drugSuggestionList: [String] = [] // Empty array of type String
    let user = Auth.auth().currentUser
    let drugNamesCollection = Firestore.firestore().collection(K.Collections.drugNamesCollection)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Assigning delegates
        tableView.dataSource = self
        tableView.delegate = self
        searchTextField.delegate = self
        searchTextField.isSelected = true
        
        searchTextField.becomeFirstResponder()
        
        tableView.register(UINib(nibName: K.DrugSuggestionCell, bundle: nil), forCellReuseIdentifier: K.reusableDrugSuggestionCell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.CheckToResult {
            if let nextViewController = segue.destination as? ResultViewController {
                // Sending the proper drug information to the next view controller
                nextViewController.drugName = drugSuggestionList[selectedRow!]
                nextViewController.prescriptions = prescriptions
            }
        }
    }
    
    //MARK: Functions
    
    // Capitalizes the first letter of a string argument
    func formatStringForQuery(_ string: String) -> String {
        let formattedString = string.prefix(1).capitalized + string.dropFirst()
        return formattedString
    }
    
    //MARK: Actions
    @IBAction func searchTermChanged(_ sender: UITextField) {
        if let searchTerm = sender.text {
            // Check if there is text in field
            if searchTerm.count > 0 {
                // Capitalize the first letter of the string
                let formattedSearchTerm = formatStringForQuery(searchTerm)
                // Query firestore
                drugNamesCollection.whereField("drugName", isGreaterThanOrEqualTo: formattedSearchTerm).limit(to: 6).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        // Append returned drugs to drugSuggestionList array
                        self.drugSuggestionList.removeAll()
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let drugName = data["drugName"] as? String {
                                    let suggestion = drugName
                                    self.drugSuggestionList.append(suggestion)
                                }
                            }
                            DispatchQueue.main.async {
                                // Updating the table
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: Extensions
extension CheckViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugSuggestionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableDrugSuggestionCell, for: indexPath) as! DrugSuggestionCell
        
        // Split the drug title on the paranthesis
        let drugTitle = drugSuggestionList[indexPath.row].split(separator: "(", maxSplits: 1, omittingEmptySubsequences: false)
        // Take first part of drug title (this is the simple name)
        let drugName = String(drugTitle[0])
        cell.drugNameLabel.text = drugName
        // Hide the subtitle in case we don't use it
        cell.subtitleLabel.isHidden = true
        // If there is more than one element in the splitted string array
        // set the drug suggestion cell subtitle to that second element
        if drugTitle.count > 1 {
            // Make sure to remove the last paranthesis in the subtitle with
            // the following prefix method
            let subtitle = String(drugTitle[1].prefix(drugTitle[1].count - 1))
            // Un-hide the subtitle
            cell.subtitleLabel.isHidden = false
            // Set the subtitle in the cell to the found subtitle
            cell.subtitleLabel.text = subtitle
        }
        return cell
    }
}

extension CheckViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}

extension CheckViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: K.Segues.CheckToResult, sender: self)
    }
}
