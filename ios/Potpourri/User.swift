//
//  User.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 10.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class User
{
    open static var current : User?
    open static var sessionId: String?

    open let id: Int
    open var email: String

    open let firstName: String
    open let lastName: String
    
    open var immigrant: Bool?
    open var gender: Bool?
    
    open var dateOfBirth: Date?
    open var dateOfImmigration: Date?

    open var nationality: String?
    
    open var locationLatitude: Int?
    open var locationLongitude: Int?
    
    init(id: Int, email: String, firstName: String, lastName: String)
    {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    init(sessionId: String, id: Int, firstName: String, lastName: String, email: String, immigrant: Bool, gender: Bool, dateOfBirth: Date, dateOfImmigration: Date, nationality: String, locationLatitude: Int, locationLongitude: Int) {
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
    
    open static func login(_ email: String, password: String, completion: @escaping ((Bool) -> Void))
    {
        let loginRequest = HTTPUserLoginRequest()
        loginRequest.send(email, password: password) { (loginSuccess: Bool) in
        
            if(loginRequest.responseValue == false || loginRequest.sessionId.isEmpty) {
                completion(false)
                return
            }
            
            print("USER ID: \(loginRequest.userId)")

            // login ok, retrieve user information
            let userDetailsRequest = HTTPUserDetailsRequest()
            userDetailsRequest.send(Int(loginRequest.userId)!) { (userDetailSuccess: Bool) in
                
                if(!userDetailSuccess) {
                    completion(false)
                }
            
                print("user: \(userDetailsRequest.email), \(userDetailsRequest.dateOfBirth)")
                
                let sqlDateFormatter = DateFormatter()
                sqlDateFormatter.dateFormat = "yyyy-MM-dd"
                
                var dateOfBirth = Date.distantPast
                if let d = sqlDateFormatter.date(from: userDetailsRequest.dateOfBirth) {
                    dateOfBirth = d
                }
                
                var dateOfImmigration = Date.distantPast
                if let d = sqlDateFormatter.date(from: userDetailsRequest.dateOfImmigration) {
                    dateOfImmigration = d
                }
                
                current = User(sessionId: loginRequest.sessionId, id: Int(loginRequest.userId)!,
                               firstName: userDetailsRequest.firstName, lastName: userDetailsRequest.lastName,
                               email: userDetailsRequest.email,
                               immigrant: NSString(string: userDetailsRequest.immigrant).boolValue, gender: NSString(string: userDetailsRequest.gender).boolValue,
                               dateOfBirth: dateOfBirth, dateOfImmigration: dateOfImmigration,
                               nationality: userDetailsRequest.nationality,
                               locationLatitude: Int(userDetailsRequest.locationLatitude)!, locationLongitude: Int(userDetailsRequest.locationLongitude)!)
                
                completion(true)
            }
        }
    }
    
    open static func autoLogin(_ completion: @escaping (Bool) -> Void)
    {
        if(!UserDefaults.standard.bool(forKey: "autologinEnabled")) {
            print("autologin net enabled")
            completion(false)
            return
        }
        
        if let email = UserDefaults.standard.string(forKey: "autologinEmail")
            ,let password = UserDefaults.standard.string(forKey: "autologinPassword") {
            if(email.isEmpty || password.isEmpty) {
                print("autologin mail or password unset")
                completion(false)
            } else {
                login(email, password: password) { (success: Bool) in
                    print("autologin successfull")

                    completion(true)
                }
            }
        } else {
            print("autologin error retrieving email or password")
            completion(false)
        }
    }
    
    open static func logout(_ completion: @escaping (Bool) -> Void)

    {
        let logoutRequest = HTTPUserLogoutRequest()
        logoutRequest.send(completion: completion)
    }
    
    open static func loggedIn() -> Bool
    {
        return current != nil;
    }
}
