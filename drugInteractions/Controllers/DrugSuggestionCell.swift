//
//  DrugSuggestionCell.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/13/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

import UIKit
import Firebase

class DrugSuggestionCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    //MARK: Variables
    //let userDrugsCollection = Firestore.firestore().collection(K.Collections.userDrugsCollection)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Functions
    
}
