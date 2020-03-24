//
//  Drug.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/13/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

struct Drug: Codable {
    var drugName: String
    var interactions: [Interaction] = []
    
    init(_ data: [String: Any]) {
        drugName = data["drugName"] as! String
        for interaction in (data["interactions"] as! [[String: Any]]) {
            interactions.append(Interaction(interaction))
        }
    }
}

struct Interaction: Codable {
    var drugName: String
    var severity: Int
    
    init(_ data: [String: Any]) {
        drugName = data["drugName"] as! String
        severity = data["severity"] as! Int 
    }
}
