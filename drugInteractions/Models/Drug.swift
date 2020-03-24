//
//  Drug.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/13/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

struct Drug {
    var drugName: String
    var interactions: [Interaction] = []
    
    init(_ data: [String: Any]) {
        drugName = data["drugName"] as! String
        for interaction in (data["interactions"] as! [[String: Any]]) {
            interactions.append(Interaction(interaction))
        }
    }
}

struct Interaction {
    var drugName: String
    var severity: Int
    
    init(_ data: [String: Any]) {
        drugName = data["drugName"] as! String
        severity = data["severity"] as! Int
    }
}

/*
func convertFirestoreArrayToSwiftArray(_ array: NSMutableArray) -> [Interaction] {
    var swiftArray: [Interaction] = []
    for item in array {
        if let dict = item as? NSMutableDictionary {
            let drugName = dict.value(forKey: "drugName") as! String
            let severity = dict.value(forKey: "severity") as! Int
            var interaction = Interaction()
            interaction.drugName = drugName
            interaction.severity = severity
            swiftArray.append(interaction)
        }
    }
    return swiftArray
}
*/
