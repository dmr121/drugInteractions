//
//  UserPrescription.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/28/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

struct UserPrescription: Codable {
    var drugName: String
    var dosage: Float
    var numDoses: Float
    var specialInstructions: String
    var id: String
    
    init() {
        drugName = ""
        dosage = 0
        numDoses = 0
        specialInstructions = ""
        id = ""
    }
    
    init(_ data: [String: Any], _ id_: String) {
        drugName = data["drugName"] as! String
        dosage = data["dosage"] as! Float
        numDoses = data["numDoses"] as! Float
        specialInstructions = data["specialInstructions"] as! String
        id = id_
    }
}
