import Foundation
import UIKit

enum GGOverlayViewMode : Int {
    case GGOverlayViewModeLeft
    case GGOverlayViewModeRight
}
extension NSCoder {
    class func empty() -> NSCoder {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.finishEncoding()
        return NSKeyedUnarchiver(forReadingWithData: data)
    }
}

class OverlayView : UIView {
    var mode : GGOverlayViewMode = GGOverlayViewMode.GGOverlayViewModeLeft;
    var imageView : UIImageView
    
    
    override init(frame: CGRect) {
        //mode = GGOverlayViewMode.GGOverlayViewModeLeft // tmp init
        imageView = UIImageView()
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
//        if(mode == GGOverlayViewMode.GGOverlayViewModeLeft) {
//            imageView.image = UIImage(named: "noButton")
//            print("YOYOYO")
//        }
        if(mode == GGOverlayViewMode.GGOverlayViewModeRight) {
            imageView.image = UIImage(named: "yesButton")
        }
        else {
            imageView.image = UIImage(named: "noButton")
            //print("YOYOYO")
        }
        self.addSubview(imageView)
    }
    
    required init(coder: NSCoder) {
        mode = GGOverlayViewMode.GGOverlayViewModeLeft // tmp init
        imageView = UIImageView()
        super.init(coder: NSCoder.empty()) //coder) //XXXXUXXXXXXXXXX
    }
    
    func setMode(mode: GGOverlayViewMode){
//        //      if (_ mode == mode) {
//        //            return
//        //        }
//        //
//        //        _mode = mode;
//        
        if(mode == GGOverlayViewMode.GGOverlayViewModeLeft) {
            imageView.image = UIImage(named: "noButton")
        } else {
            imageView.image = UIImage(named: "yesButton")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRectMake(80, 80, 150, 150)
        //imageView.backgroundColor = UIColor(red:72/255, green:145/255,blue:206/255,alpha:1)
    }
}
