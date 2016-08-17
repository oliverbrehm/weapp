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
    public var email: String

    public let firstName: String
    public let lastName: String
    
    public var immigrant: Bool?
    public var gender: Bool?
    
    public var dateOfBirth: NSDate?
    public var dateOfImmigration: NSDate?

    public var nationality: String?
    
    public var locationLatitude: Int?
    public var locationLongitude: Int?
    
    init(id: Int, email: String, firstName: String, lastName: String)
    {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    init(sessionId: String, id: Int, firstName: String, lastName: String, email: String, immigrant: Bool, gender: Bool, dateOfBirth: NSDate, dateOfImmigration: NSDate, nationality: String, locationLatitude: Int, locationLongitude: Int) {
        self.id = id
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email;
        
        self.immigrant = immigrant
        self.gender = gender
        
        self.dateOfBirth = dateOfBirth
        self.dateOfImmigration = dateOfImmigration
        
        self.nationality = nationality
        
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
        
        User.sessionId = sessionId;
    }
    
    public static func login(email: String, password: String) -> User?
    {
        let loginRequest = HTTPUserLoginRequest()
        loginRequest.send(email, password: password)
        
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
                       email: userDetailsRequest.email,
                       immigrant: NSString(string: userDetailsRequest.immigrant).boolValue, gender: NSString(string: userDetailsRequest.gender).boolValue,
                       dateOfBirth: dateOfBirth, dateOfImmigration: dateOfImmigration,
                       nationality: userDetailsRequest.nationality,
                       locationLatitude: Int(userDetailsRequest.locationLatitude)!, locationLongitude: Int(userDetailsRequest.locationLongitude)!)
        
        return current
    }
    
    public static func autoLoginAsync(completion: (User?) -> Void) -> Void
    {
        if(!NSUserDefaults.standardUserDefaults().boolForKey("autologinEnabled")) {
            print("autologin net enabled")
            completion(nil)
            return
        }
        
        if let email = NSUserDefaults.standardUserDefaults().stringForKey("autologinEmail")
            ,let password = NSUserDefaults.standardUserDefaults().stringForKey("autologinPassword") {
            if(email.isEmpty || password.isEmpty) {
                print("autologin mail or password unset")
                completion(nil)
                return
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let user = login(email, password: password)
                print("autologin successfull")

                dispatch_async(dispatch_get_main_queue()) {
                    completion(user)
                    return
                }
            }
            
            return
        }
        
        print("autologin error retrieving email or password")
        completion(nil)
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