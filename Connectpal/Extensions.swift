import UIKit

extension String {
    var htmlSafe:String {
//      return self
//        return NSAttributedString(data: dataUsingEncoding(NSUnicodeStringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil, error: nil)!.string
        
        var result = self
        
        result = result.replacingOccurrences(of: "<p>", with: "\n\n", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "</p>", with: "", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "<i>", with: "", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "</i>", with: "", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "&#38;", with: "&", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "&#39;", with: "'", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "&#62;", with: ">", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "&#x27;", with: "'", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "&#x2F;", with: "/", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "&quot;", with: "\"", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "&#60;", with: "<", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "&lt;", with: "<", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "&gt;", with: ">", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "&amp;", with: "&", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "<pre><code>", with: "", options: .caseInsensitive, range: nil)
        result = result.replacingOccurrences(of: "</code></pre>", with: "", options: .caseInsensitive, range: nil)
        
        //var regex = NSRegularExpression(pattern: "<a[^>]+href=\"(.*?)\"[^>]*>.*?</a>",
        //    options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
        //result = regex!.stringByReplacingMatchesInString(result, options: nil, range: NSMakeRange(0, count(result.utf16)), withTemplate: "$1")
        
        return result
    }
}
