import Foundation
import UIKit
import MessageUI

class SendMessageClass : UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var data : NSDictionary?
    @IBOutlet var subject: UITextField!
    @IBOutlet var body: UITextField!
    
    @IBAction func sendMail(sender: AnyObject) {
        var picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject(subject.text)
        picker.setMessageBody(body.text, isHTML: true)
        picker.setToRecipients(["lesamisdepepito@gmail.com"])
        
        presentViewController(picker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subject.delegate = self
        body.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        let name = data!["name"] as! String
        subject.text = "Chat \(name)"
        
        super.viewDidAppear(animated)
    }
    
    // MFMailComposeViewControllerDelegate
    
    // 1
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // UITextFieldDelegate
    
    // 2
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // UITextViewDelegate
    
    // 3
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        body.text = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
}
