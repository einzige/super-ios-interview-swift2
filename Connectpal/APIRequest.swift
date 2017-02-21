import Foundation

open class APIRequest {
    let host = "http://localhost:3000"
    let namespace = "/api"
    
    var token: String?
    
    public init(token: String? = nil) {
        self.token = token
    }
    
    open func get(_ path: String, params: [String: AnyObject]? = nil) -> APIResponse {
        return getJSON(buildURL(path))
    }
    
    open func post(_ path: String, params: [String: AnyObject]? = nil) -> APIResponse {
        return postJSON(buildURL(path), data: params as AnyObject?)
    }
    
    fileprivate func buildURL(_ path: String) -> String {
        return (host + namespace + "/" + path).replacingOccurrences(of: "//", with: "/")
    }
    
    fileprivate func getJSON(_ url: String) -> APIResponse {
        return sendRequest(buildHTTPRequest(url))
    }
    
    fileprivate func postJSON(_ url: String, data: AnyObject? = nil) -> APIResponse {
        let request = buildHTTPRequest(url, type: "POST")
        
        if data != nil {
            request.httpBody = toJSON(data!).data(using: String.Encoding.utf8)
        }
    
        return sendRequest(request)
    }
    
    fileprivate func buildHTTPRequest(_ url: String, type: String = "GET") -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token != nil {
            request.setValue("Token token=\(token!)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = type
        
        return request
    }
    
    fileprivate func sendRequest(_ request: NSMutableURLRequest) -> APIResponse {
        var response: URLResponse?
        var e: NSError?
        let data: Data?
        do {
            data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
        } catch let error as NSError {
            e = error
            data = nil
        }
        
        if e != nil {
            return APIResponse(data: ["error": e!.localizedDescription as AnyObject])
        }
        
        if data != nil {
            return APIResponse(data: responseDataToDictionary(data!))
        }
        
        return APIResponse(data: [String: AnyObject]())
    }
    
    fileprivate func responseDataToDictionary(_ data: Data) -> [String: AnyObject] {
        guard let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
            return [String: AnyObject]()
        }
        return jsonObj!
    }
    
    fileprivate func toJSON(_ value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
        
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: options) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String {
                    return string
                }
            }
        }
        return ""
    }
}
