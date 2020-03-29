import UIKit

struct K {
    static let appName = "💊Pharmkit"
    static let DrugSuggestionCell = "DrugSuggestionCell"
    static let reusableDrugSuggestionCell = "reusableDrugSuggestionCell"
    static let UserPrescriptionCell = "UserPrescriptionCell"
    static let reusableUserPrescriptionCell = "reusableUserPrescriptionCell"
    
    struct Segues {
        static let RegisterToPrescriptions = "RegisterToPrescriptions"
        static let LoginToPrescriptions = "LoginToPrescriptions"
        static let StartupToRegister = "StartupToRegister"
        static let StartupToLogin = "StartupToLogin"
        static let PrescriptionToAdd = "PrescriptionToAdd"
        static let AddButtonSegue = "AddButtonSegue"
    }
    
    struct Collections {
        static let pharmacyCollection = "pharmacy"
        static let drugNamesCollection = "drugNames"
        static let usersCollection = "users"
    }
    
    struct Colors {
        static let orange = UIColor.systemOrange
    }
}
