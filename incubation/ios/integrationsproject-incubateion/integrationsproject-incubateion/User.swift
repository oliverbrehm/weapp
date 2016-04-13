//
//  User.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 10.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

public class User
{
    public static var current : User?
    public static var sessionId: String?

    public let id: Int
    
    public let firstName: String
    public let lastName: String

    public var mail: String?
    
    public var immigrant: Bool?
    public var gender: Bool?
    
    public var dateOfBirth: NSDate?
    public var dateOfImmigration: NSDate?

    public var nationality: String?
    
    public var locationLatitude: Int?
    public var locationLongitude: Int?
    
    init(id: Int, firstName: String, lastName: String)
    {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init(sessionId: String, id: Int, firstName: String, lastName: String, mail: String, immigrant: Bool, gender: Bool, dateOfBirth: NSDate, dateOfImmigration: NSDate, nationality: String, locationLatitude: Int, locationLongitude: Int) {
        self.id = id
        
        self.firstName = firstName
        self.lastName = lastName
        self.mail = mail;
        
        self.immigrant = immigrant
        self.gender = gender
        
        self.dateOfBirth = dateOfBirth
        self.dateOfImmigration = dateOfImmigration
        
        self.nationality = nationality
        
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
        
        User.sessionId = sessionId;
    }
    
    public static func login(mail: String, password: String) -> User?
    {
        let loginRequest = HTTPUserLoginRequest()
        loginRequest.send(mail, password: password)
        
        if(loginRequest.responseValue == false || loginRequest.sessionId.isEmpty) {
            return nil
        }

        let userDetailsRequest = HTTPUserDetailsRequest()
        userDetailsRequest.send(Int(loginRequest.userId)!)
        
        print("user: \(userDetailsRequest.email), \(userDetailsRequest.dateOfBirth)")
        
        let sqlDateFormatter = NSDateFormatter()
        sqlDateFormatter.dateFormat = "yyyy-MM-dd"
        
        var dateOfBirth = NSDate.distantPast()
        if let d = sqlDateFormatter.dateFromString(userDetailsRequest.dateOfBirth) {
            dateOfBirth = d
        }
        
        var dateOfImmigration = NSDate.distantPast()
        if let d = sqlDateFormatter.dateFromString(userDetailsRequest.dateOfImmigration) {
            dateOfImmigration = d
        }
        
        current = User(sessionId: loginRequest.sessionId, id: Int(loginRequest.userId)!,
                       firstName: userDetailsRequest.firstName, lastName: userDetailsRequest.lastName,
                       mail: userDetailsRequest.email,
                       immigrant: NSString(string: userDetailsRequest.immigrant).boolValue, gender: NSString(string: userDetailsRequest.gender).boolValue,
                       dateOfBirth: dateOfBirth, dateOfImmigration: dateOfImmigration,
                       nationality: userDetailsRequest.nationality,
                       locationLatitude: Int(userDetailsRequest.locationLatitude)!, locationLongitude: Int(userDetailsRequest.locationLongitude)!)
        
        return current
    }
    
    public static func logout() -> Bool
    {
        let logoutRequest = HTTPUserLogoutRequest()
        logoutRequest.send()
        
        return logoutRequest.responseValue
    }
    
    public static func loggedIn() -> Bool
    {
        return current != nil;
    }
}