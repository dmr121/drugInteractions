//
//  UserPrescriptionCell.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/30/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

import UIKit

class UserPrescriptionCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var alternateNamesLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var numDosesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
