import Foundation
import UIKit

class ViewController : UIViewController {
    let DEFAULT_IMAGE = "IMAGES/catinder/test/cat-default.jpg"
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var wantsOutside: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var data : NSDictionary?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let cat = data {
            let url : String
            if let images = cat["images"] as? NSDictionary {
                url = images[0] as! String
            } else {
                url = DEFAULT_IMAGE
            }

            let data = NSData(contentsOfURL: NSURL(string: url)!)
            imageView.image = UIImage(data: data!)

            if let description = cat["description"] as? String {
                descriptionLabel.text = description
            } else {
                descriptionLabel.text = "(pas de description)"
            }
            if let color = cat["color"] as? String {
                colorLabel.text = color
            } else {
                colorLabel.text = "(couleur non définie)"
            }
            if let race = cat["race"] as? String {
                raceLabel.text = race
            } else {
                raceLabel.text = "(race non définie)"
            }
            if let name = cat["name"] as? String {
                nameLabel.text = name
            } else {
                nameLabel.text = "(nom non défini)"
            }
            if let age = cat["age"] as? Int {
                ageLabel.text = String(age)
            } else {
                ageLabel.text = "(age non défini)"
            }
            
            if cat["wantsOutside"] == nil || (cat["wantsOutside"] as? Bool) == false {
                wantsOutside.text = "Non"
            } else {
                wantsOutside.text = "Oui"
            }
        } else {
            fatalError("Trying to display a view for no cat")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
