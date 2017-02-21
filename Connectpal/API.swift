import Foundation

open class API {
    open var token: String?
    fileprivate var request: APIRequest
    
    public init(token: String? = nil) {
        self.token = token
        self.request = APIRequest(token: token)
    }
    
    open func signIn(_ email: String, password: String, callback: ((APIResponse) -> ())?) {
        {
            return self.post("/sessions", params: ["email": email, "password": password])
        } ~> { (response: APIResponse) in
            let token = response.getToken()
            
            // Authorize app once token is received
            if token != nil { self.authorize(token) }
            if callback != nil { callback!(response) }
        }
    }
    
    open func feed() -> APIResponse {
        return self.get("/posts/feed")
    }
    
    open func resetSession() {
        self.token = nil
    }
    
    open func isAuthorized() -> Bool {
        return token != nil
    }
    
    fileprivate func get(_ path: String, params: [String: String]? = nil) -> APIResponse {
        return request.get(path, params: params as [String : AnyObject]?)
    }
    
    fileprivate func post(_ path: String, params: [String: String]? = nil) -> APIResponse {
        return request.post(path, params: params as [String : AnyObject]?)
    }
    
    fileprivate func authorize(_ token: String?) {
        self.token = token
        self.request = APIRequest(token: token)
    }
}

public var api = API()
