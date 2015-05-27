
import UIKit

func eval(value: String?) -> String {
    return value==nil ? "" : value!
}

class Patient {
    init(
        first_name: String,
        last_name: String,
        street_1: String,
        street_2: String?,
        city: String,
        state: String,
        zip: String
    ) {
        self.first_name = first_name
        self.last_name = last_name
        self.street_1 = street_1
        self.street_2 = street_2
        self.city = city
        self.state = state
        self.zip = zip
    }
    var first_name: String
    var last_name: String
    var street_1: String
    var street_2: String?
    var city: String
    var state: String
    var zip: String
    func toDic() -> Dictionary<String,AnyObject> {
        return [
            "first_name": self.first_name,
            "last_name": self.last_name,
            "address": [
                "street_1": self.street_1,
                "street_2": eval(self.street_2),
                "city": self.city,
                "state": self.state,
                "zip": self.zip
            ]
        ]
    }
}

class Payer {
    init() {
        
    }
    func toDic() -> Dictionary<String,String> {
        return [:]
    }
}

class Prescriber {
    init(
        npi: String?,
        first_name: String?,
        last_name: String?
    ) {
        self.npi = npi
        self.first_name = first_name
        self.last_name = last_name
    }
    var npi: String?
    var first_name: String?
    var last_name: String?
    func toDic() -> Dictionary<String,String> {
        return [
            "npi": eval(self.npi),
            "first_name": eval(self.first_name),
            "last_name": eval(self.last_name)
        ]
    }
}

class Prescription {
    init(
        drug_id: String?
    ) {
        self.drug_id = drug_id
    }
    var drug_id: String?
    func toDic() -> Dictionary<String,String> {
        return [
            "drug_id": eval(self.drug_id)
        ]
    }
}

class PriorAuthorization {
    init(patient: Patient, payer: Payer, prescriber: Prescriber, prescription: Prescription) {
        self.patient = patient
        self.payer = payer
        self.prescriber = prescriber
        self.prescription = prescription
    }
    var id: String?
    var token: String?
    let patient: Patient
    let payer: Payer
    let prescriber: Prescriber
    let prescription: Prescription
}


