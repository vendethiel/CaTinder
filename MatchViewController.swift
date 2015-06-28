import UIKit

class MatchViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    let DEFAULT_IMAGE = "IMAGES/catinder/test/cat-default.jpg"
    var matchedCat : NSDictionary?
    
    override func viewDidAppear(animated: Bool) {
        let images = matchedCat!["images"] as! NSArray
        let image : String
        if images.count > 0 {
            image = images[0] as! String
        } else {
            image = DEFAULT_IMAGE
        }
        let url = NSURL(string: image)
        let data = NSData(contentsOfURL: url!)
        imageView.image = UIImage(data: data!)!
        
        super.viewDidAppear(animated)
    }
    
    // forward data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sendEmail" {
            if let ctrl = segue.destinationViewController as? SendMessageClass {
                
                ctrl.data = matchedCat
            }
        }
    }
}
