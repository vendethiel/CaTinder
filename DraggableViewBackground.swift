import Foundation
import UIKit


class DraggableViewBackground : UIView {
    let DEFAULT_IMAGE = "IMAGES/catinder/test/cat-default.jpg"
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //this makes it so only two cards are loaded at a time to
    //avoid performance and memory costs
    
    let MAX_BUFFER_SIZE = 5 //%%% max number of cards loaded at any given time, must be greater than 1
    let CARD_HEIGHT : CGFloat = 240  //%%% height of the draggable card
    let CARD_WIDTH : CGFloat = 240 //%%% width of the draggable card

    var cards = [DraggableView]()
    
    var checkButton : UIButton
    var xButton : UIButton
    
    var isLoading = false
    
    override init(frame: CGRect) {

        checkButton = UIButton()
        xButton = UIButton()
        super.init(frame: frame)
        self.setupView()
        
        self.loadCards()
    }
    
    //  Frontend UI styling happening here
    func setupView() {

        //  Styling xButton
        xButton = UIButton(frame: CGRectMake(60, 385, 59, 59))
        xButton.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
        
        //  Add target for checkButton (Swipe Left)
        xButton.addTarget(self, action: "swipeLeft", forControlEvents: UIControlEvents.TouchUpInside)
        
        //  Styling checkButton
        checkButton = UIButton(frame: CGRectMake(240, 385, 59, 59))
        checkButton.setImage(UIImage(named: "checkButton"), forState: UIControlState.Normal)
        
        //  Add target for checkButton (Swipe Right)
        checkButton.addTarget(self, action: "swipeRight", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add subviews
        self.addSubview(xButton)
        self.addSubview(checkButton)
    }
    
    func loadCards() {
        if isLoading || cards.count > 0 {
            return
        }
        isLoading = true
        
        let requestHelper = RequestHelper()
        cards = [DraggableView]()
        requestHelper.getCats({(cats) in
            var lastCard : DraggableView?
            for cat in cats {
                var newCard = self.createDraggableViewWithData(cat as! NSDictionary)
                self.cards.append(newCard)
                
                if lastCard != nil {
                    self.insertSubview(newCard, belowSubview: lastCard!)
                } else {
                    self.addSubview(newCard)
                }
                lastCard = newCard
            }
            self.isLoading = false
        })
    }
    
    func createDraggableViewWithData(cat: NSDictionary) -> DraggableView{
        var draggableView : DraggableView = DraggableView(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/4, CARD_WIDTH, CARD_HEIGHT)) // on divise par 4 pour la taille
        draggableView.data = cat
        
        draggableView.information.text = cat["name"] as? String
        let images = cat["images"] as! NSArray
        let image : String
        if images.count > 0 {
            image = images[0] as! String
        } else {
            image = DEFAULT_IMAGE
        }
        let url = NSURL(string: image)
        let data = NSData(contentsOfURL: url!)
        draggableView.imageBack.backgroundColor = UIColor(patternImage: UIImage(data: data!)!)
        return draggableView
    }
    
    func viewController() -> UIViewController? {
        var next = superview;
        while next != nil
        {
            let nextResponder = next!.nextResponder()
            
            if let vc = nextResponder as? UIViewController {
                return vc
            }
            next = next!.superview
        }
        
        return nil
    }
    
    private func goAndLike(card: DraggableView, like: Bool, callback: (NSDictionary) -> () = {(result) in}) {
        
        let requestHelper = RequestHelper()
        requestHelper.doLike(card.data!["id"] as! Int, like: false, callback: {(result) in
            if let error = result["error"] as? String {
                var alert = UIAlertController(title: "Erreur - Dislike", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                if let vc = self.viewController() {
                    vc.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                callback(result)
            }
        })
    }
    
    // DISLIKE
    func cardSwipedLeft(cardView: UIView) {
        cards.removeAtIndex(0)
        cardView.removeFromSuperview()
        
        let card = cardView as! DraggableView
        goAndLike(card, like: false)
    }
    
    // LIKE
    func cardSwipedRight(cardView: UIView) {
        cards.removeAtIndex(0)
        cardView.removeFromSuperview()
        
        let card = cardView as! DraggableView
        goAndLike(card, like: true, callback: {(result) in
            if let vc = self.viewController() {
                vc.performSegueWithIdentifier("match", sender: card)
            }
        })
    }
    
    //%%% when you hit the right button, this is called and substitutes the swipe
    func swipeRight() {
        if cards.count == 0 {
            return
        }
        
        var dragView : DraggableView = cards.first!
        dragView.overlayView.mode = GGOverlayViewMode.GGOverlayViewModeLeft
        UIView.animateWithDuration(0.2, animations: { () in
            dragView.overlayView.alpha = 1
        })
        cardSwipedRight(dragView)
        dragView.rightClickAction()
    }
    
    func swipeLeft() {
        if cards.count == 0 {
            return
        }
        
        var dragView : DraggableView = cards.first!
        dragView.overlayView.mode = GGOverlayViewMode.GGOverlayViewModeLeft
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            dragView.overlayView.alpha = 1
        })
        //loadedCards.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        ///overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        cardSwipedLeft(dragView)
        dragView.leftClickAction()
    }
}
