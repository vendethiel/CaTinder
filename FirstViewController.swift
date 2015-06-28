import UIKit

class FirstViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var loginButton: FBSDKLoginButton!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO check if we already have a token
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.delegate = self
        }
    }
    
    @IBAction func login(sender: UIButton) {
        let requestHelper = RequestHelper()

        requestHelper.doLogin(email.text as String, password: password.text as String,
            callback: { (user: NSDictionary) -> Void in
                if let error: AnyObject = user["error"] {
                    self.password.text = ""
                    
                    var alert = UIAlertController(title: "Erreur", message: "Impossible de se connecter avec cette combinaison nom de compte/mot de passe", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let token = user["token"] as! String
                    let emailAddr = user["email"] as! String
                    NSLog("token is %@", token)
                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    for key in ["token", "email", "name"] {
                        userDefaults.setObject(user[key] as! String, forKey:key)
                    }
                    
                    self.performSegueWithIdentifier("login", sender: self)
                }
        })
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
                graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                    if (error != nil) {
                        let alert = UIAlertController(title: "Erreur", message: "Erreur de connexion vers Facebook", preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        var email = result.valueForKey("email") as! NSString
                        NSLog("%@", email)
                    }
                })
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
}