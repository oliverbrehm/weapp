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
    
    open let sessionId: String
    open let id: Int
    
    open var email: String?
    open var firstName: String?
    open var lastName: String?
    
    open var immigrant: Bool?
    open var gender: Bool?
    
    open var dateOfBirth: Date?
    open var dateOfImmigration: Date?

    open var nationality: String?
    
    open var locationLatitude: Int?
    open var locationLongitude: Int?
    
    open var invitations : InvitationList?
    open var participations : InvitationList?
    open var joinRequests : JoinRequestList?
    
    // use for arbitrary users, id and display name
    init(id: Int, firstName: String)
    {
        self.id = id
        self.firstName = firstName
        self.sessionId = ""
    }
    
    // use for logged in user
    init(id: Int, sessionId: String)
    {
        self.id = id
        self.sessionId = sessionId
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
        
        if let email = UserDefaults.standard.string(forKey: "autologinEmail")
            ,let password = UserDefaults.standard.string(forKey: "autologinPassword") {
            if(email.isEmpty || password.isEmpty) {
                print("autologin mail or password unset")
                completion(false)
            } else {
                login(email, password: password, completion: completion)
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
    
    open func queryDetails(completion: @escaping (Bool) -> Void)
    {
        let userDetailsRequest = HTTPUserDetailsRequest()
        userDetailsRequest.send(self.id) { (success: Bool) in
            
            if(!success) {
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
            

            self.firstName = userDetailsRequest.firstName
            self.lastName = userDetailsRequest.lastName
            self.email = userDetailsRequest.email
            self.immigrant = NSString(string: userDetailsRequest.immigrant).boolValue
            self.gender = NSString(string: userDetailsRequest.gender).boolValue
            self.dateOfBirth = dateOfBirth
            self.dateOfImmigration = dateOfImmigration
            self.nationality = userDetailsRequest.nationality
            self.locationLatitude = Int(userDetailsRequest.locationLatitude)
            self.locationLongitude = Int(userDetailsRequest.locationLongitude)
            
            completion(true)
        }
        
        completion(true)
    }
    
    open func queryInvitations(completion: @escaping (Bool) -> Void)
    {
        self.invitations = InvitationList(city: "", sortingCriteria: .Date, owner: self, participatingUser: nil)
        self.invitations?.fetch(number: 100, completion: completion)
    }
    
    open func queryParticipations(completion: @escaping (Bool) -> Void)
    {
        self.participations = InvitationList(city: "", sortingCriteria: .Date, owner: nil, participatingUser: self)
        self.participations?.fetch(number: 100, completion: completion)
    }
    
    open func queryJoinRequests(completion: @escaping (Bool) -> Void)
    {
        self.joinRequests = JoinRequestList(for: self)
        self.joinRequests?.fetch(max: 100, completion: completion)
    }
}
