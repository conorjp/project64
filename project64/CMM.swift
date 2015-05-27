
import UIKit
import SwiftHTTP
import SwiftyJSON

class CMM {
    init() {
        self.request.baseURL = "https://api.covermymeds.com"
    }
    let apiID = "eg5p1nkkihr50mv13j9p"
    let apiSecret = "d3buvh9hjmkp64j2w6v-5scpipyd9ienhffcs937"
    var request = HTTPTask()
    func responseToJSON(#response: HTTPResponse?) -> JSON {
        var json: JSON = nil
        if let data = response!.responseObject as? NSData {
            json = JSON(data: data)
        }
        return json
    }
    func testForPA(PA: PriorAuthorization, callback: (result: (PARequired: Bool, autostart: Bool)?) -> Void) {
        let params: Dictionary<String,AnyObject> = [
            "patient": PA.patient.toDic(),
            "payer": PA.payer.toDic(),
            "prescriber": PA.prescriber.toDic(),
            "prescription": PA.prescription.toDic(),
            "v": 1,
            "api_id": self.apiID
        ]
        var result: (Bool,Bool)?
        self.request.POST(
            "/indicators",
            parameters: params,
            success: {(response: HTTPResponse) in
                let json: JSON = self.responseToJSON(response: response)
                let PARequired: Bool = json["indicator"]["prescription"]["pa_required"].object as! Bool
                let autostart: Bool = json["indicator"]["prescription"]["autostart"].object as! Bool
                callback(result: (PARequired: PARequired, autostart: autostart))
            },
            failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
                println(self.responseToJSON(response: response))
                callback(result: nil)
            }
        )
    }
    func makeRequestWithPA(PA: PriorAuthorization, callback: (requestID: String, token: String) -> Void) {
        let params: Dictionary<String,AnyObject> = [
            "request": [
                "state": PA.patient.state,
                "patient": PA.patient.toDic(),
                "payer": PA.payer.toDic(),
                "prescriber": PA.prescriber.toDic(),
                "prescription": PA.prescription.toDic()
            ],
            "v": 1,
            "api_id": self.apiID,
        ]
        self.request.POST(
            "/requests",
            parameters: params,
            success: {(response: HTTPResponse) in
                let json: JSON = self.responseToJSON(response: response)
                let token = json["request"]["tokens"][0]["id"]
                let request_id = json["request"]["tokens"][0]["request_id"]
                callback(
                    requestID: request_id.object as! String,
                    token: token.object as! String
                )
            },
            failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
                println(self.responseToJSON(response: response))
            }
            
        )
    }
    func modifyPA(PA: PriorAuthorization) {
        
    }
    func checkForUpdatesOfPAs(PAs: [PriorAuthorization], callback: (responseArray: [(decision: String?, status: String)]) -> Void) {
        var tokens: Array<String> = Array()
        for PA in PAs {
            tokens.append(PA.token!)
        }
        var params: Dictionary<String,AnyObject> = [
            "token_ids": tokens,
            "v": 1,
            "api_id": self.apiID
        ]
        self.request.POST(
            "/requests/search",
            parameters: params,
            success: {(response: HTTPResponse) in
                let json: JSON = self.responseToJSON(response: response)
                var decisionsAndStatuses: Array<(decision: String?, status: String)> = Array()
                println(json)
                for (index,request) in json["requests"] {
                    let decision: String? = request["response_from_plan"].object as? String
                    let status: String = request["workflow_status"].object as! String
                    decisionsAndStatuses.append(
                        (decision: decision, status: status)
                    )
                }
                callback(responseArray: decisionsAndStatuses)
            },
            failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
                println(self.responseToJSON(response: response))
            }
            
        )
    }
}

