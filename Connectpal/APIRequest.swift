import Foundation

public class APIRequest {
    let host = "http://localhost:3000"
    let namespace = "/api"
    
    var token: String?
    
    public init(token: String? = nil) {
        self.token = token
    }
    
    public func get(path: String, params: [String: AnyObject]? = nil) -> APIResponse {
        return getJSON(buildURL(path))
    }
    
    public func post(path: String, params: [String: AnyObject]? = nil) -> APIResponse {
        return postJSON(buildURL(path), data: params)
    }
    
    private func buildURL(path: String) -> String {
        return (host + namespace + "/" + path).stringByReplacingOccurrencesOfString("//", withString: "/")
    }
    
    private func getJSON(url: String) -> APIResponse {
        return sendRequest(buildHTTPRequest(url))
    }
    
    private func postJSON(url: String, data: AnyObject? = nil) -> APIResponse {
        let request = buildHTTPRequest(url, type: "POST")
        
        if data != nil {
            request.HTTPBody = toJSON(data!).dataUsingEncoding(NSUTF8StringEncoding)
        }
    
        return sendRequest(request)
    }
    
    private func buildHTTPRequest(url: String, type: String = "GET") -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token != nil {
            request.setValue("Token token=\(token!)", forHTTPHeaderField: "Authorization")
        }
        
        request.HTTPMethod = type
        
        return request
    }
    
    private func sendRequest(request: NSMutableURLRequest) -> APIResponse {
        var response: NSURLResponse?
        var e: NSError?
        let data: NSData?
        do {
            data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        } catch let error as NSError {
            e = error
            data = nil
        }
        
        if e != nil {
            return APIResponse(data: ["error": e!.localizedDescription])
        }
        
        if data != nil {
            return APIResponse(data: responseDataToDictionary(data!))
        }
        
        return APIResponse(data: [String: AnyObject]())
    }
    
    private func responseDataToDictionary(data: NSData) -> [String: AnyObject] {
        guard let jsonObj = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
            return [String: AnyObject]()
        }
        return jsonObj!
    }
    
    private func toJSON(value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : []
        
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = try? NSJSONSerialization.dataWithJSONObject(value, options: options) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                    return string
                }
            }
        }
        return ""
    }
}