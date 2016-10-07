//
//  Invitation.swift
//  weApp
//
//  Created by Oliver Brehm on 13.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class Invitation
{
    open let invitationId: Int
    
    open let name: String
    
    open var description = ""
    open var maxParticipants = 0
    open var date = Date.distantPast
    open var locationCity = ""
    open var locationStreet = ""
    open var locationStreetNumber = 0
    open var locationLatitude = 0
    open var locationLongitude = 0
    
    open var owner: User?
    
    open var participants: [User] = []
    open var messages : MessageList?

    var runningQuery = false
    
    init(invitationId: Int, name: String)
    {
        self.invitationId = invitationId
        self.name = name
    }
    
    init(invitationId: Int, name: String, ownerId: Int, ownerFirstName: String, description: String, maxParticipants: Int, date: Date,
         locationCity: String, locationStreet: String, locationStreetNumber: Int, locationLatitude: Int, locationLongitude: Int)
    {
        self.invitationId = invitationId
        self.name = name
        
        self.owner = User(id: ownerId, firstName: ownerFirstName)
        
        self.description = description
        self.maxParticipants = maxParticipants
        self.date = date
        self.locationCity = locationCity
        self.locationStreet = locationStreet
        self.locationStreetNumber = locationStreetNumber
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
    }
    
    open func createdByUser(_ user: User?) -> Bool
    {
        if(user == nil || self.owner == nil) {
            return false
        }
        
        return user!.id == self.owner!.id
    }
    
    open static func create(_ name : String, detailedDescription : String,
                              maxParticipants : Int, nsDate : Date,
                              locationCity : String, locationStreet : String, locationStreetNumber : Int,
                              locationLatitude : Int, locationLongitude : Int, completion: @escaping ((Bool) -> Void))
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: nsDate)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh-mm"
        let time = timeFormatter.string(from: nsDate)
        
        let request = QueryInvitationCreate()
        request.send(name, detailedDescription: detailedDescription, maxParticipants: maxParticipants, date: date, time: time, locationCity: locationCity, locationStreet: locationStreet, locationStreetNumber: locationStreetNumber, locationLatitude: locationLatitude, locationLongitude: locationLongitude, completion: completion)
    }
    
    func createJoinRequest(_ user: User, numParticipants: Int, completion: @escaping ((Bool) -> Void))
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = QueryJoinRequestCreate()
        request.send(self.invitationId, userId: user.id, numParticipants: numParticipants) { (success: Bool) in
            self.runningQuery = false; completion(success)
        }
    }
    
    func queryParticipants(completion: @escaping (Bool) -> Void)
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = QueryInvitationParticipants()
        request.send(self.invitationId) { (success: Bool) in
            
            self.participants = request.participants
            if(self.owner != nil) {
                self.participants.insert(self.owner!, at: 0)
            }
            
            self.runningQuery = false; completion(success)
        }
    }
    
    func queryMessages(completion: @escaping (Bool) -> Void)
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        // TODO add option to query only a few (eg 2) recent messages
        self.messages = MessageList(invitation: self)
        self.messages!.fetch(max: 100) { (success: Bool) in
            self.runningQuery = false; completion(success)
        }
    }
    
    func delete(completion: @escaping (Bool) -> Void)
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = QueryInvitationDelete()
        request.send(self.invitationId) { (success : Bool) in
            self.runningQuery = false; completion(success)
        }
    }
    
    func update(_ name : String, detailedDescription : String,
                maxParticipants : Int, nsDate : Date,
                locationCity : String, locationStreet : String, locationStreetNumber : Int,
                locationLatitude : Int, locationLongitude : Int, completion: @escaping (Bool) -> Void)
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: nsDate)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh-mm"
        let time = timeFormatter.string(from: nsDate)
        
        let request = QueryInvitationUpdate()
        request.send(invitationId: self.invitationId, name: name, detailedDescription: detailedDescription, maxParticipants: maxParticipants, date: date, time: time, locationCity: locationCity, locationStreet: locationStreet, locationStreetNumber: locationStreetNumber, locationLatitude: locationLatitude, locationLongitude: locationLongitude) { (success : Bool) in
            self.runningQuery = false; completion(success)
        }
        
        self.runningQuery = false; completion(true)
    }
    
    open func queryDetails(completion: @escaping ((Bool) -> Void))
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = QueryInvitationDetail()
        request.send(self.invitationId) { (success: Bool) in
        
            if(request.responseValue == false) {
                self.runningQuery = false; completion(false)
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            self.owner = User(id: (Int(request.ownerId))!, firstName: request.ownerFirstName)

            self.description = request.invitationDescription
            self.maxParticipants = Int(request.maxParticipants)!
            
            let date = dateFormatter.date(from: request.date) // TODO include time
            if(date != nil) {
                self.date = date!
            }
            
            self.locationCity = request.locationCity
            self.locationStreet = request.locationStreet
            self.locationStreetNumber = Int(request.locationStreetNumber)!
            self.locationLatitude = Int(request.locationLatitude)!
            self.locationLongitude = Int(request.locationLongitude)!
            
            self.runningQuery = false; completion(true)
        }
    }
    
    open func postMessage(user: User, message: String, completion: @escaping ((Bool) -> Void))
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = QueryMessagePost()
        request.send(invitationId: self.invitationId, message: message) { (success : Bool) -> Void in
            self.runningQuery = false
            completion(success)
        }
    }
}
