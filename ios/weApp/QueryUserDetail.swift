//
//  UserRequest.swift
//  weApp
//
//  Created by Oliver Brehm on 11.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryUserDetail: Query
{
    open var user: User?
    
    var name = ""
    var firstName = ""
    var lastName = ""
    var immigrant = ""
    var gender = ""
    var dateOfBirth = ""
    var nationality = ""
    var mail = ""
    var dateOfImmigration = ""
    var locationLatitude = ""
    var locationLongitude = ""
    
    open func send(_ userId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.User.Details)&\(Arguments.User.UserId)=\(userId)"
        super.sendHTTPPost(data: postData, completion: completion)
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
        case "Mail":
            self.mail = self.currentString
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
