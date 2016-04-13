//
//  UserRequest.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 11.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

public class HTTPUserDetailsRequest: HTTPRequest
{
    public var user: User?
    
    var name = ""
    var firstName = ""
    var lastName = ""
    var immigrant = ""
    var gender = ""
    var dateOfBirth = ""
    var nationality = ""
    var email = ""
    var dateOfImmigration = ""
    var locationLatitude = ""
    var locationLongitude = ""
    
    public func send(userId: Int) -> Bool {
        let postData = "action=user_get_details&user_id=\(userId)"
        return super.sendPost(postData)
    }
    
    public override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        switch(elementName) {
        case "Name":
            self.name = self.currentString
            break
        case "FirstName":
            self.firstName = self.currentString
            break
        case "LastName":
            self.lastName = self.currentString
            break
        case "Immigrant":
            self.immigrant = self.currentString
            break
        case "Gender":
            self.gender = self.currentString
            break
        case "DateOfBirth":
            self.dateOfBirth = self.currentString
            break
        case "Nationality":
            self.nationality = self.currentString
            break
        case "Email":
            self.email = self.currentString
            break
        case "DateOfImmigration":
            self.dateOfImmigration = self.currentString
            break
        case "LocationLatitude":
            self.locationLatitude = self.currentString
            break
        case "LocationLongitude":
            self.locationLongitude = self.currentString
            break
            
        default: break
        }
    }
}

public class HTTPUserLoginRequest: HTTPRequest
{
    public var userId = ""
    public func send(mail: String, password: String) -> Bool
    {
        let postData = "action=user_login&username=\(mail)&password=\(password)"
        return super.sendPost(postData)
    }
    
    public override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        if(elementName == "UserID") {
            self.userId = self.currentString
        }
    }
}

public class HTTPUserLogoutRequest: HTTPRequest
{
    public var userId = ""
    public func send() -> Bool
    {
        let postData = "action=user_logout"
        return super.sendPost(postData)
    }
}
