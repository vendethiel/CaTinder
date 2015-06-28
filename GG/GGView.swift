import UIKit

class GGView: UIView {

    var draggableView:GGDraggableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        println("InitGGView")
        self.backgroundColor = UIColor.whiteColor()
        self.loadDraggableCustomView()
    }
    
    func loadDraggableCustomView(){
        self.draggableView = GGDraggableView()
        //let image = UIImage(data: "background.png")
        self.draggableView.backgroundColor = UIColor.whiteColor()  //.greenColor() //(patternImage: UIImage(named:"background")!)
        self.draggableView.frame = CGRectMake(35, 80, 300, 300)
        self.addSubview(self.draggableView)
        
    }
    
    func layoutSubViews()
    {
        super.layoutSubviews()
        self.draggableView.frame = CGRectMake(60, 60, 200, 260)
    }
    
    
}
