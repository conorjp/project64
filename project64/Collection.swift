
import UIKit

class Collection {
    init() {
        self.processes = Array()
        self.coverMyMeds = CMM()
    }
    var processes: Array<Process>
    let coverMyMeds: CMM
    func makeNewProcess() {
        let process = Process(collection: self, coverMyMeds: self.coverMyMeds)
        process.beginProcess()
        self.processes.append(process)
    }
    func checkForUpdates(#completionHandler: (UIBackgroundFetchResult) -> Void) {
//        func callback(#responseArray: [(decision: String?, status: String)]) {
//            var newData: Bool = true
//            var fetchResult: UIBackgroundFetchResult
//            if newData {
//                fetchResult = .NewData
//                self.sendDecisionNotification()
//            } else {
//                fetchResult = .NoData
//            }
//            completionHandler(fetchResult)
//        }
//        var PAs: Array<PriorAuthorization> = Array()
//        for process in self.processes {
//            PAs.append(process.PA!)
//        }
//        self.coverMyMeds.checkForUpdatesOfPAs(PAs, callback: callback)
        self.sendDecisionNotification()
        completionHandler(.NoData)
    }
    func sendDecisionNotification() {
        let notification = UILocalNotification()
        notification.alertTitle = "News from pap!"
        notification.alertAction = "See details"
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            println("active")
        } else if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
            println("background")
        } else if UIApplication.sharedApplication().applicationState == UIApplicationState.Inactive {
            println("inactive")
        }
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
}

