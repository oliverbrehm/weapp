//
//  Invitation.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 13.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class InvitationList
{
    enum SorginCriteria
    {
        case Area
        case Date
    }
    
    var sortingCriteria = SorginCriteria.Date
    var city = ""
    var owner: User?
    var participatingUser: User?
    
    private var invitations : [Invitation] = []
    
    var runningQuery = false
    
    init(city: String, sortingCriteria: SorginCriteria, owner: User?, participatingUser: User?) {
        self.sortingCriteria = sortingCriteria
        self.city = city
        self.owner = owner
        self.participatingUser = participatingUser
    }
    
    func count() -> Int
    {
        return self.invitations.count
    }
    
    func isEmpty() -> Bool
    {
        return count() == 0
    }
    
    func invitation(index: Int) -> Invitation
    {
        return self.invitations[index]
    }
    
    func fetch(number: Int, completion: @escaping ((Bool) -> Void))
    {
        // TODO consider number
        // TODO consider sorting
        
        if(self.participatingUser != nil) {
            let request = HTTPInvitationParticipatingListRequest() // TODO combine to one request with HTTPInvitationListRequest
            
            if(self.runningQuery) { completion(false); return }
            self.runningQuery = true

            request.send(self.participatingUser!) { (success: Bool) in
                if(request.responseValue == false) {
                    self.runningQuery = false; completion(false)
                    return
                }
                
                for invitationHeader in request.invitations {
                    let invitationId = Int(invitationHeader.id)!
                    self.invitations.append(Invitation(invitationId: invitationId, name: invitationHeader.name))
                }
                
                self.runningQuery = false; completion(true)
            }

        } else {
            let request = HTTPInvitationListRequest()
            
            if(self.runningQuery) { completion(false); return }
            self.runningQuery = true
            
            request.send(owner: self.owner) { (success: Bool) in
                if(request.responseValue == false) {
                    self.runningQuery = false; completion(false)
                    return
                }
                
                for invitationHeader in request.invitations {
                    let invitationId = Int(invitationHeader.id)!
                    self.invitations.append(Invitation(invitationId: invitationId, name: invitationHeader.name))
                }
                
                print("invitations: \(self.invitations.count)")
                
                self.runningQuery = false; completion(true)
            }
        }
        

    }
    
    func refresh(max: Int, completion: @escaping ((Bool) -> Void))
    {
        self.invitations.insert(Invitation(invitationId: 0, name: "REFRESH DUMMY"), at: 0)
    }
}

open class Invitation
{
    open let invitationId: Int
    
    open let name: String
    
    open var owner: User?
    
    open var description: String?
    open var maxParticipants: Int?
    open var date: Date?
    open var locationCity: String?
    open var locationStreet: String?
    open var locationStreetNumber: Int?
    open var locationLatitude: Int?
    open var locationLongitude: Int?
    
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
        
        let request = HTTPInvitationCreateRequest()
        request.send(name, detailedDescription: detailedDescription, maxParticipants: maxParticipants, date: date, time: time, locationCity: locationCity, locationStreet: locationStreet, locationStreetNumber: locationStreetNumber, locationLatitude: locationLatitude, locationLongitude: locationLongitude, completion: completion)
    }
    
    func createJoinRequest(_ user: User, numParticipants: Int, completion: @escaping ((Bool) -> Void))
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = HTTPInvitationJoinRequest()
        request.send(self.invitationId, userId: user.id, numParticipants: numParticipants) { (success: Bool) in
            self.runningQuery = false; completion(success)
        }
    }
    
    func queryParticipants(completion: @escaping (Bool) -> Void)
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = HTTPInvitationGetParticipantsRequest()
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
        self.messages = MessageList(invitationId: self.invitationId)
        self.messages!.fetch(max: 100) { (success: Bool) in
            self.runningQuery = false; completion(success)
        }
    }
    
    func delete(completion: @escaping (Bool) -> Void)
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = HTTPInvitationDeleteRequest()
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
        
        let request = HTTPInvitationUpdateRequest()
        request.send(invitationId: self.invitationId, name: name, detailedDescription: detailedDescription, maxParticipants: maxParticipants, date: date, time: time, locationCity: locationCity, locationStreet: locationStreet, locationStreetNumber: locationStreetNumber, locationLatitude: locationLatitude, locationLongitude: locationLongitude) { (success : Bool) in
            self.runningQuery = false; completion(success)
        }
        
        self.runningQuery = false; completion(true)
    }
    
    open func queryDetails(completion: @escaping ((Bool) -> Void))
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = HTTPInvitationDetailRequest()
        request.send(self.invitationId) { (success: Bool) in
        
            if(request.responseValue == false) {
                self.runningQuery = false; completion(false)
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            self.owner = User(id: (Int(request.ownerId))!, firstName: request.ownerFirstName)

            self.description = request.invitationDescription
            self.maxParticipants = Int(request.maxParticipants)
            self.date = dateFormatter.date(from: request.date) // TODO include time
            self.locationCity = request.locationCity
            self.locationStreet = request.locationStreet
            self.locationStreetNumber = Int(request.locationStreetNumber)
            self.locationLatitude = Int(request.locationLatitude)
            self.locationLongitude = Int(request.locationLongitude)
            
            self.runningQuery = false; completion(true)
        }
    }
    
    open func postMessage(user: User, message: String, completion: @escaping ((Bool) -> Void))
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = HTTPPostMessageRequest()
        request.send(invitationId: self.invitationId, message: message) { (success : Bool) -> Void in
            self.runningQuery = false
            completion(success)
        }
    }
}
