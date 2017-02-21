import Foundation

open class SessionManager {
    open var userData: [String: AnyObject] = [String: AnyObject]()
    
    open func signIn(_ email: String, password: String,
        onSuccess: (() -> ())? = nil,
        onFail: (() -> ())? = nil)
    {
        api.signIn(email, password: password) { response in
            if self.isSignedIn() {
                let responseData = response.getData()
                
                if responseData["user"] != nil {
                    self.userData = responseData["user"] as! [String: AnyObject]
                }
                
                onSuccess?()
            } else {
                onFail?()
            }
        }
    }
    
    open func registrationToken() -> String? {
        return userData["registration_token"] as? String
    }
    
    open func isSignedIn() -> Bool {
        return api.isAuthorized()
    }
    
    open func signOut() {
        api.resetSession()
    }
}

let sessionManager = SessionManager()
