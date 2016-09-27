//
//  UserRequest.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 11.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class HTTPUserDetailsRequest: HTTPRequest
{
    open var user: User?
    
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
    
    open func send(_ userId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=user_get_details&user_id=\(userId)"
        super.sendPost(postData, completion: completion)
    }
    
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        switch(elementName) {
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

open class HTTPUserLoginRequest: HTTPRequest
{
    open var userId = ""
    open func send(_ email: String, password: String, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=user_login&email=\(email)&password=\(password)"
        super.sendPost(postData, completion: completion)
    }
    
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        if(elementName == "UserID") {
            self.userId = self.currentString
        }
    }
}

open class HTTPUserLogoutRequest: HTTPRequest
{
    open var userId = ""
    open func send(completion: @escaping ((Bool) -> Void))    {
        let postData = "action=user_logout"
        super.sendPost(postData, completion: completion)
    }
}

open class HTTPUserRegisterRequest: HTTPRequest
{
    open var userId = ""
    open func send(_ email: String, password: String, firstName: String, lastName: String,
                     userType: Bool, gender: Bool,
                     dateOfBirth: Date, nationality: String,
                     dateOfImmigration: Date,
                     locationLatitude: Int, locationLongitude: Int, completion: @escaping ((Bool) -> Void))
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let immigrationDateString = dateFormatter.string(from: dateOfImmigration)
        let birthDateString = dateFormatter.string(from: dateOfBirth)
        
        let postData =
        "action=user_register&" +
        
        "email=\(email)&" +
        "password=\(password)&" +
        "firstName=\(firstName)&" +
        "lastName=\(lastName)&" +
        "userType=\(userType)&" +
        "gender=\(gender)&" +
        "dateOfBirth=\(birthDateString)&" +
        "nationality=\(nationality)&" +
        "dateOfImmigration=\(immigrationDateString)&" +
        "locationLatitude=\(locationLatitude)&" +
        "locationLongitude=\(locationLongitude)&"
        
        super.sendPost(postData, completion: completion)
    }
}
