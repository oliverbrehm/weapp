//
//  User.swift
//  weApp
//
//  Created by Oliver Brehm on 10.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class User
{
    open static var current : User?
    
    open let sessionId : String
    open let id: Int
    
    open var mail = ""
    open var firstName = ""
    open var lastName = ""
    
    open var immigrant = false
    open var gender = false
    
    open var dateOfBirth = Date.distantPast
    open var dateOfImmigration = Date.distantPast

    open var nationality = ""
    
    open var locationLatitude = 0
    open var locationLongitude = 0
    
    open var invitations : InvitationList?
    open var participations : InvitationList?
    open var joinRequests : JoinRequestList?
    
    // use for arbitrary users, id and display name
    init(id: Int, firstName: String)
    {
        self.id = id
        self.sessionId = ""
        
        self.firstName = firstName
    }
    
    // use for logged in user
    init(id: Int, sessionId: String)
    {
        self.id = id
        self.sessionId = sessionId
    }
    
    /**
     Tries to log in the user with given mail and password.
     
     - parameter mail:      the user's mail address for logging in
     - parameter password:  the user's password for logging in
     - completion: called   as soon as the login request has completed
     */
    open static func login(_ mail: String, password: String, completion: @escaping ((Bool) -> Void))
    {
        let loginRequest = QueryUserLogin()
        loginRequest.send(mail, password: password) { (loginSuccess: Bool) in
        
            if(loginRequest.responseValue == false || loginRequest.sessionId.isEmpty) {
                completion(false)
                return
            }
            
            print("USER ID: \(loginRequest.userId)")

            User.current = User(id: Int(loginRequest.userId)!, sessionId: loginRequest.sessionId)

            // login ok, retrieve user information
            User.current?.queryDetails(completion: completion)
        }
    }
    
    open static func autoLogin(_ completion: @escaping (Bool) -> Void)
    {
        if(!UserDefaults.standard.bool(forKey: "autologinEnabled")) {
            print("autologin net enabled")
            completion(false)
            return
        }
        
        if let mail = UserDefaults.standard.string(forKey: "autologinmail")
            ,let password = UserDefaults.standard.string(forKey: "autologinPassword") {
            if(mail.isEmpty || password.isEmpty) {
                print("autologin mail or password unset")
                completion(false)
            } else {
                login(mail, password: password, completion: completion)
            }
        } else {
            print("autologin error retrieving mail or password")
            completion(false)
        }
    }
    
    open static func logout(_ completion: @escaping (Bool) -> Void)

    {
        let logoutRequest = QueryUserLogout()
        logoutRequest.send(completion: completion)
    }
    
    open static func loggedIn() -> Bool
    {
        return current != nil;
    }
    
    open static func register(mail: String, password: String, firstName: String, lastName: String, immigrant: Bool, gender: Bool, dateOfBirth: Date, nationality: String, dateOfImmigration: Date, locationLatitude: Int, locationLongitude: Int, completion: @escaping (Bool) -> Void)
    {
        let registerRequest = QueryUserRegister()
        registerRequest.send(mail, password: password, firstName: firstName, lastName: lastName, userType: immigrant, gender: gender, dateOfBirth: dateOfBirth, nationality: nationality, dateOfImmigration: dateOfImmigration, locationLatitude: locationLatitude, locationLongitude: locationLongitude, completion: completion)
    }
    
    open func queryDetails(completion: @escaping (Bool) -> Void)
    {
        let userDetailsRequest = QueryUserDetail()
        userDetailsRequest.send(self.id) { (success: Bool) in
            
            if(!success) {
                completion(false)
                return
            }
            
            print("user: \(userDetailsRequest.mail), \(userDetailsRequest.dateOfBirth)")
            
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

            self.firstName = userDetailsRequest.firstName
            self.lastName = userDetailsRequest.lastName
            self.mail = userDetailsRequest.mail
            self.immigrant = NSString(string: userDetailsRequest.immigrant).boolValue
            self.gender = NSString(string: userDetailsRequest.gender).boolValue
            self.dateOfBirth = dateOfBirth
            self.dateOfImmigration = dateOfImmigration
            self.nationality = userDetailsRequest.nationality
            
            let locationLatitude = Int(userDetailsRequest.locationLatitude)
            if(locationLatitude != nil) {
                self.locationLatitude = locationLatitude!
            }
            let locationLongitude = Int(userDetailsRequest.locationLongitude)
            if(locationLongitude != nil) {
                self.locationLongitude = locationLongitude!
            }
            
            completion(true)
        }
    }
    
    open func queryInvitations(completion: @escaping (Bool) -> Void)
    {
        self.invitations = InvitationList(city: "", sortingCriteria: .Date)
        self.invitations?.fetch(owner: self, number: 100, completion: completion)
    }
    
    open func queryParticipations(completion: @escaping (Bool) -> Void)
    {
        self.participations = InvitationList(city: "", sortingCriteria: .Date)
        self.participations?.fetch(participatingUser: self, number: 100, completion: completion)
    }
    
    open func queryJoinRequests(completion: @escaping (Bool) -> Void)
    {
        self.joinRequests = JoinRequestList(for: self)
        self.joinRequests?.fetch(max: 100, completion: completion)
    }
}
