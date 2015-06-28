import Foundation
import UIKit

let ACTION_MARGIN = 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH = 4 //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX : CGFloat = 1 //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX = 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH = 320 //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE = M_PI/8 //%%% Higher = stronger rotation angle

class DraggableView : UIView {
    var xFromCenter : CGFloat
    var yFromCenter : CGFloat
    var panGestureRecognizer : UIPanGestureRecognizer
    var originalPoint : CGPoint
    var overlayView : OverlayView
    var information : UILabel
    var imageBack   : UIView
    var viewOverlay : UIView
    var data : NSDictionary?
    
    required init(coder aDecoder: NSCoder) {
        xFromCenter = 0.0
        yFromCenter = 0.0
        panGestureRecognizer = UIPanGestureRecognizer()
        originalPoint = CGPoint()
        overlayView = OverlayView(coder: aDecoder)
        information = UILabel()
        imageBack   = UIView()
        viewOverlay = UIView()
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        xFromCenter = 0.0
        yFromCenter = 0.0
        panGestureRecognizer = UIPanGestureRecognizer()
        originalPoint = CGPoint()
        overlayView = OverlayView(coder: NSCoder())
        information = UILabel()
        imageBack = UIView()
        viewOverlay = UIView()
        super.init(frame: frame)
        imageBack   = UIView(frame: CGRectMake(0, 0, self.frame.size.width, 240))
        information = UILabel(frame: CGRectMake(0, 190, self.frame.size.width, 50))
        information.text = "no info given"
        information.textAlignment = NSTextAlignment.Center
        information.textColor = UIColor.whiteColor()
        information.backgroundColor = UIColor(red:0/255, green:0/255,blue:0/255,alpha:0.5)

        self.backgroundColor = UIColor.whiteColor()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "beingDragged:")
        
        self.addGestureRecognizer(panGestureRecognizer)
        self.addSubview(imageBack)
        self.addSubview(information)
        overlayView = OverlayView(frame: CGRectMake(0, 0, 240, 240))
        overlayView.alpha = 0
        self.addSubview(overlayView)
        
        self.superview
    }
    
    func setupView() {
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
    
    //%%% called when you move your finger across the screen.
    // called many times a second
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer){
        //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
        
        //%%% positive for right swipe, negative for left
        xFromCenter = gestureRecognizer.translationInView(self).x
        //%%% positive for up, negative for down
        yFromCenter = gestureRecognizer.translationInView(self).y
        
        //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
        switch (gestureRecognizer.state) {
            //%%% just started swiping
            
        case UIGestureRecognizerState.Began:
            self.originalPoint = self.center
            break
            
            
            //%%% in the middle of a swipe
        case UIGestureRecognizerState.Changed:
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            var rotationStrength = min(CGFloat(xFromCenter) / CGFloat(ROTATION_STRENGTH), CGFloat(ROTATION_MAX)) as CGFloat
            
            //%%% degree change in radians
            var rotationAngel : CGFloat = (CGFloat(ROTATION_ANGLE) * rotationStrength)
            
            //%%% amount the height changes when you move the card up to a certain point
            var scale = max((CGFloat(1) - CGFloat(rotationStrength) / CGFloat(SCALE_STRENGTH)), SCALE_MAX) as CGFloat
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter)
            
            //%%% rotate by certain amount
            var transform : CGAffineTransform = CGAffineTransformMakeRotation(rotationAngel)
            
            //%%% scale by certain amount
            var scaleTransform : CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            
            //%%% apply transformations
            self.transform = scaleTransform
            
            self.updateOverlay(xFromCenter)
            
            break
            
            //%%% let go of the card
        case UIGestureRecognizerState.Ended:
            self.afterSwipeAction()
            break;
            
        case UIGestureRecognizerState.Possible:break;
        case UIGestureRecognizerState.Cancelled:break;
        case UIGestureRecognizerState.Failed:break;
        }
        
    }
    //%%% checks to see if you are moving right or left and applies the correct overlay image
    func updateOverlay(distance: CGFloat){
        
        if (distance > 0) {
            overlayView.mode = GGOverlayViewMode.GGOverlayViewModeLeft;
            overlayView.alpha = min(CGFloat(distance)/(100), 0.4);
            overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight);
        }
        else if (distance < 0) {
            overlayView.mode = GGOverlayViewMode.GGOverlayViewModeRight;
            overlayView.alpha = min(CGFloat(distance)/(-100), 0.4);
            overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft);
        }

    }
    //%%% called when the card is let go
    func afterSwipeAction() {
        if(xFromCenter > CGFloat(ACTION_MARGIN))
        {
            self.rightAction()
        }
        else if(xFromCenter < CGFloat(-(ACTION_MARGIN)))
        {
            self.leftAction()
        }
        else
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.center = self.originalPoint
                self.transform = CGAffineTransformMakeRotation(0)
                self.overlayView.alpha = 0
            })
        }
    }
    
    func rightAction() {
        var finishPoint : CGPoint = CGPointMake(500, 2*yFromCenter + self.originalPoint.y)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = finishPoint
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        
        println("YES")
        // TODO!!
    }
    
    func leftAction() {
        var finishPoint : CGPoint = CGPointMake(-500, 2*yFromCenter + self.originalPoint.y)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = finishPoint
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        
        // TODO!
        println("NO")
        
    }
    //var checkButton : UIButton
    //var viewOverlay : UIView
    
    func rightClickAction() {
        var finishPoint : CGPoint = CGPointMake(600, self.center.y)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(1)
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        // TODO dislike
        println("Yes")
    }
    
    func leftClickAction() {
        var finishPoint : CGPoint = CGPointMake(-600, self.center.y)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(-1)
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        // TODO like
        println("No")
        
    }
    
}
