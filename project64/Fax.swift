
import UIKit
import SwiftHTTP
import SwiftyJSON

class Fax {
    init(faxNumber: String, content: String) {
        self.faxNumber = faxNumber
        self.content = content
        self.request.baseURL = "https://api.phaxio.com/v1"
    }
    var apiKey: String = "bf2f45d8f13071812b02a6ab1bcd3ba61bea6e11"//"28e17aa32c5c5b92fc839482102746c1b4ace2f7"
    var apiSecret: String = "3f5e02cc90893be1aac4c1b760fbae61ea71ac1b"//"04ff0d47c91ea453fafcc51de245aea6cbe15c14"
    var faxNumber: String
    var content: String
    var request = HTTPTask()
    func responseToJSON(#response: HTTPResponse?) -> JSON {
        var json: JSON = nil
        if let data = response!.responseObject as? NSData {
            json = JSON(data: data)
        }
        return json
    }
    func send() {
        var params: Dictionary<String,AnyObject> = [
            "to": self.faxNumber,
            "string_data": self.content,
            "api_key": self.apiKey,
            "api_secret": self.apiSecret
        ]
        request.POST(
            "/send",
            parameters: params,
            success: {(response: HTTPResponse) in
                let json: JSON = self.responseToJSON(response: response)
                println(json)
            },
            failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
                println(self.responseToJSON(response: response))
            }
        )
    }
}