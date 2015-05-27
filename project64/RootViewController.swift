

import UIKit

class RootViewController: UIViewController {
    init() {
        super.init(nibName:nil,bundle:nil)
        let viewFrame: CGRect = UIScreen.mainScreen().bounds
        self.view = RootView(frame: viewFrame)
        self.mainMenu = MainMenu(frame: viewFrame)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // no needed
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

