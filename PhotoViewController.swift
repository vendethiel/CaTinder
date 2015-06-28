import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
