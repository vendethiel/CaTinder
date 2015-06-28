import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    var draggableBackground : DraggableViewBackground?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        draggableBackground = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(draggableBackground!)
    }
    @IBAction func doRefresh(sender: AnyObject) {
        draggableBackground?.loadCards()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "info" || identifier == "match" {
            if let bg = draggableBackground {
                // we are to have a cat if we
                if let cat = bg.cards.first, data = cat.data {
                    return true
                }
            }
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "info" {
            if let ctrl = segue.destinationViewController as? ViewController, bg = draggableBackground {
                // we are to have a cat if we 
                if let cat = bg.cards.first, data = cat.data {
                    ctrl.data = data
                }
            }
        } else if segue.identifier == "match" {
            if let ctrl = segue.destinationViewController as? MatchViewController, dragBg = sender! as? DraggableView {
                ctrl.matchedCat = dragBg.data
            }
        }
    }
}
