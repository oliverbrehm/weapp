//
//  HTTPRequest.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 11.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class HTTPRequest: NSObject, XMLParserDelegate
{
    open var responseValue = false
    open var sessionId = ""
    open var responseString = ""
    
    var currentString = ""
    
    internal func sendPost(_ postData: String, completion: @escaping ((Bool) -> Void))
    {
        let request = NSMutableURLRequest(url: URL(string: "http://vocab-book.com/integrationsprojekt/develop/interface/API.php")!)
        // TODO use HTTPS? normally HTTP is not even supported (hack in Project -> target -> Info -> App Transport Security Settings)
        
        request.httpMethod = "POST"
        
        request.httpBody = postData.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                completion(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            print("responseString = \(self.responseString)")
            
            // cookies
            for cookie in HTTPCookieStorage.shared.cookies! {
                print(cookie.name)
                if(cookie.name == "PHPSESSID") {
                    self.sessionId = cookie.value
                }
            }
            
            print("sessionId: \(self.sessionId)")
            
            if(self.sessionId.isEmpty || self.responseString.isEmpty) {
                completion(false)
            } else {
                // get the xml response value
                let data = self.responseString.data(using: String.Encoding.utf8)
                let xmlParser = XMLParser(data: data!)
                xmlParser.delegate = self
                
                xmlParser.parse()
                
                completion(true)
            }
        }
        
        task.resume();
    }

    open func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if(elementName == "response") {
            if let success = attributeDict["success"] {
                self.responseValue = NSString(string: success).boolValue
                print("RESPONSE: \(self.responseValue)")
            }
        }
        
        self.currentString = ""
    }
    
    open func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    open func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        
    }
    
    open func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString.append(string)
    }
}
