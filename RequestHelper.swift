import UIKit

class RequestHelper {
    let LOGIN_URL = "http://localhost:3000/api/users/authenticate.json?email=%@&password=%@"
    let CATS_URL = "http://localhost:3000/api/cats.json?email=%@&token=%@"
    let CAT_LIKE_URL = "http://localhost:3000/api/cat_likes?email=%@&token=%@&cat_id=%d&like=%d"

    func request<T>(url:String, callback: (T) -> (), errCallback: (NSError) -> () = {(error) in}) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        performRequest(request, callback: callback)
    }
    
    func postRequest<T>(url:String, callback: (T) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"

        performRequest(request, callback: callback)
    }
    
    private func performRequest<T>(request: NSURLRequest, callback: (T) -> ()) {
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if error == nil {
                var jsonError:NSError?
                var response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as! T
                callback(response)
            }
        }
    }
    
    func doLogin(email: String, password: String, callback: (NSDictionary) -> ()) {
        let url = NSString(format: String(format: LOGIN_URL, email, password))
        NSLog("hey %@", url)
        request(url as String, callback: callback)
    }
    
    func getCats(callback: (NSArray) -> ()) {
        let (email, token) = getEmailAndToken()
        request(String(format: CATS_URL, email!, token!), callback: callback)
    }
    
    func doLike(cat: Int, like: Bool, callback: (NSDictionary) -> ()) {
        let (email, token) = getEmailAndToken()
        NSLog("going to like with %@", String(format: CAT_LIKE_URL, email!, token!, cat, like ? 1 : 0))
        request(String(format: CAT_LIKE_URL, email!, token!, cat, like ? 1 : 0), callback: callback)
    }
    
    private func getEmailAndToken() -> (NSString?, NSString?) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return (userDefaults.stringForKey("email"), userDefaults.stringForKey("token"))
    }
}