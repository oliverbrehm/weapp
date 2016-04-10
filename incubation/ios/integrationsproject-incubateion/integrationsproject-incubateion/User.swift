//
//  User.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 10.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

public class ResponseParser: NSObject, NSXMLParserDelegate
{
    public var responseValue = false
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if(elementName == "response") {
            if let success = attributeDict["success"] {
                self.responseValue = NSString(string: success).boolValue
                print("RESPONSE: \(self.responseValue)")
            }
        }
    }
    
    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String) {
        
    }
    
    public func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
    }
}

public class User
{
    public static var current : User?
    
    public let mail: String
    public let name: String
    public let sessionId: String
    
    public static func login(mail: String, password: String) -> User?
    {
        var sessionId = ""
        var responseString = ""
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://vocab-book.com/integrationsprojekt/develop/interface/API.php")!)
        // TODO use HTTPS? normally HTTP is not even supported (hack in Project -> target -> Info -> App Transport Security Settings)
        
        request.HTTPMethod = "POST"
        
        let postString = "action=user_login&username=\(mail)&password=\(password)"

        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        var locked = true // TODO very bad hack
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                locked = false
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            print("responseString = \(responseString)")
            
            // cookies
            for cookie in NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies! {
                print(cookie.name)
                if(cookie.name == "PHPSESSID") {
                    sessionId = cookie.value
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
            return nil
        }
        
        // get the xml response value
        let data = responseString.dataUsingEncoding(NSUTF8StringEncoding)
        let xmlParser = NSXMLParser(data: data!)
        
        let responseParser = ResponseParser()
        
        xmlParser.delegate = responseParser
        
        xmlParser.parse()
        
        if(responseParser.responseValue == false) {
            return nil
        }
        
        current = User(mail: mail, sessionId: sessionId)
        
        return current
    }
    
    public static func loggedIn() -> Bool
    {
        return current != nil;
    }
    
    init(mail: String, sessionId: String)
    {
        self.mail = mail;
        self.name = "Horst"
        self.sessionId = sessionId;
    }
}