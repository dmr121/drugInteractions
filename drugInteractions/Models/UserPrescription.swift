//
//  UserPrescription.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/28/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

struct UserPrescription: Codable {
    let drugName: String
    var dosage: Float
    var numDoses: Float
    var specialInstructions: String
    
    init(_ data: [String: Any]) {
        drugName = data["drugName"] as! String
        dosage = data["dosage"] as! Float
        numDoses = data["numDoses"] as! Float
        specialInstructions = data["specialInstructions"] as! String
    }
}
