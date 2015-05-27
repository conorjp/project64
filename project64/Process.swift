
import UIKit
import SwiftHTTP

// QFUG9Q
// 6r3y33ta5upq6vzai1zb
// dads fax number 866 849 7805
class Process {
    init(collection: Collection, coverMyMeds: CMM) {
        self.collection = collection
        self.coverMyMeds = coverMyMeds
        self.fingertipFormulary = FF()
        self.selectPatient()
        self.selectPayer()
        self.selectPrescriber()
        self.getPrescription()
    }
    // PROPERTIES
    let collection: Collection?
    let coverMyMeds: CMM
    let fingertipFormulary: FF
    var PA: PriorAuthorization?
    var patient: Patient?
    var payer: Payer?
    var prescriber: Prescriber?
    var prescription: Prescription?
    // CAST
    func selectPatient() {
        self.patient = Patient(
            first_name: "John",
            last_name: "Doe",
            street_1: "Flower",
            street_2: nil,
            city: "Wood",
            state: "Ohio",
            zip: "12345"
        )
    }
    func selectPayer() {
        self.payer = Payer()
    }
    func selectPrescriber() {
        self.prescriber = Prescriber(npi: "0123456789", first_name: "Blair", last_name: "Blue")
    }
    func getPrescription() {
        self.prescription = Prescription(drug_id: "131079")
    }
    // PROCESS
    func beginProcess() {
        self.PA = PriorAuthorization(
            patient: self.patient!,
            payer: self.payer!,
            prescriber: self.prescriber!,
            prescription: self.prescription!
        )
//        self.testCMMForPA()
//        self.PA!.id = "QFUG9Q"
//        self.PA!.token = "6r3y33ta5upq6vzai1zb"
    }
    // testing for pa
    func testCMMForPA() {
        func callback(result: (PARequired: Bool, autostart: Bool)?) {
            self.testFFForPA(result)
            println("result \(result)")
        }
        self.coverMyMeds.testForPA(self.PA!, callback: callback)
    }
    func testFFForPA(CMMResult: (PARequired: Bool, autostart: Bool)?) {
        func callback(PARequired: Bool?) {
            self.comparePATests(
                CMMResult: CMMResult,
                FFPARequired: PARequired
            )
        }
        self.fingertipFormulary.testForPA(self.PA!, callback: callback)
    }
    func comparePATests(
        #CMMResult: (PARequired: Bool, autostart: Bool)?,
        FFPARequired: Bool?
    ) {
        var PARequired = true
        if CMMResult != nil {
            if CMMResult!.PARequired == false && FFPARequired! == false {
                PARequired = false
            }
        }
        // more analysis
        if PARequired {
            self.makePA()
        }
    }
    // launching PA
    func makePA() {
        func callback(#requestID: String, #token: String) {
            self.PA!.id = requestID
            self.PA!.token = token
            self.notifyOfBeginQuestions()
        }
        self.coverMyMeds.makeRequestWithPA(self.PA!, callback: callback)
    }
    func notifyOfBeginQuestions() {
        Fax(faxNumber: "8668497805", content: "Answer questions for patient").send()
    }
    // handling decision
    func notifyOfApproval() {
        Fax(faxNumber: "8668497805", content: "Prior authorization for patient was approved").send()
    }
}



