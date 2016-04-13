//
//  HTTPRequest.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 11.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

public class HTTPRequest: NSObject, NSXMLParserDelegate
{
    public var responseValue = false
    public var sessionId = ""
    public var responseString = ""
    
    var currentString = ""
    
    internal func sendPost(postData: String) -> Bool
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://vocab-book.com/integrationsprojekt/develop/interface/API.php")!)
        // TODO use HTTPS? normally HTTP is not even supported (hack in Project -> target -> Info -> App Transport Security Settings)
        
        request.HTTPMethod = "POST"
        
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        
        var locked = true // TODO very bad hack
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                locked = false
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            self.responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            print("responseString = \(self.responseString)")
            
            // cookies
            for cookie in NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies! {
                print(cookie.name)
                if(cookie.name == "PHPSESSID") {
                    self.sessionId = cookie.value
                }
            }
            
            locked = false
        }
        task.resume();
        
        while(locked) { // TODO hack, REMOVE!
            sleep(1)
        }
        
        print("sessionId: \(sessionId)")
        
        if(sessionId.isEmpty || responseString.isEmpty) {
            return false
        }
        
        // get the xml response value
        let data = responseString.dataUsingEncoding(NSUTF8StringEncoding)
        let xmlParser = NSXMLParser(data: data!)
        xmlParser.delegate = self
        
        xmlParser.parse()
        
        return true
    }
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if(elementName == "response") {
            if let success = attributeDict["success"] {
                self.responseValue = NSString(string: success).boolValue
                print("RESPONSE: \(self.responseValue)")
            }
        }
        
        self.currentString = ""
    }
    
    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    public func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String) {        
        self.currentString.appendContentsOf(string)
    }
}