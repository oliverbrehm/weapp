//
//  Invitation.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 13.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

public class Participant
{
    public let userId: Int
    public let firstName: String
    public let numPersons: Int
    
    init(userId: Int, firstName: String, numPersons: Int)
    {
        self.userId = userId
        self.firstName = firstName
        self.numPersons = numPersons
    }
}

public class Invitation
{
    private let invitationId: Int
    
    public let name: String
    
    public var ownerId: Int?
    public var ownerName: String?
    public var description: String?
    public var maxParticipants: Int?
    public var date: NSDate?
    public var locationCity: String?
    public var locationStreet: String?
    public var locationStreetNumber: Int?
    public var locationLatitude: Int?
    public var locationLongitude: Int?
    
    init(invitationId: Int, name: String)
    {
        self.invitationId = invitationId
        self.name = name
    }
    
    init(invitationId: Int, name: String, ownerId: Int, ownerName: String, description: String, maxParticipants: Int, date: NSDate,
         locationCity: String, locationStreet: String, locationStreetNumber: Int, locationLatitude: Int, locationLongitude: Int)
    {
        self.invitationId = invitationId
        self.name = name
        
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.description = description
        self.maxParticipants = maxParticipants
        self.date = date
        self.locationCity = locationCity
        self.locationStreet = locationStreet
        self.locationStreetNumber = locationStreetNumber
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
    }
    
    public func createdByUser(user: User?) -> Bool
    {
        if(user == nil || self.ownerId == nil) {
            return false
        }
        
        return user!.id == self.ownerId!
    }
    
    public static func create(name : String, detailedDescription : String,
                              maxParticipants : Int, nsDate : NSDate,
                              locationCity : String, locationStreet : String, locationStreetNumber : Int,
                              locationLatitude : Int, locationLongitude : Int) -> Bool
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.stringFromDate(nsDate)
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "hh-mm"
        let time = timeFormatter.stringFromDate(nsDate)
        
        let request = HTTPInvitationCreateRequest()
        request.send(name, detailedDescription: detailedDescription, maxParticipants: maxParticipants, date: date, time: time, locationCity: locationCity, locationStreet: locationStreet, locationStreetNumber: locationStreetNumber, locationLatitude: locationLatitude, locationLongitude: locationLongitude)
        
        return request.responseValue
    }
    
    func createJoinRequest(user: User, numParticipants: Int) -> Bool
    {
        let request = HTTPInvitationJoinRequest()
        request.send(self.invitationId, userId: user.id, numParticipants: numParticipants)
        
        return request.responseValue
    }
    
    func getParticipants() -> [Participant]
    {
        let request = HTTPInvitationGetParticipantsRequest()
        request.send(self.invitationId)
        
        return request.participants
    }
    
    public func queryDetails()
    {
        let request = HTTPInvitationDetailRequest()
        request.send(self.invitationId)
        
        if(request.responseValue == false) {
            return
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.ownerId = Int(request.ownerId)
        self.ownerName = request.ownerName
        self.description = request.invitationDescription
        self.maxParticipants = Int(request.maxParticipants)
        self.date = dateFormatter.dateFromString(request.date) // TODO include time
        self.locationCity = request.locationCity
        self.locationStreet = request.locationStreet
        self.locationStreetNumber = Int(request.locationStreetNumber)
        self.locationLatitude = Int(request.locationLatitude)
        self.locationLongitude = Int(request.locationLongitude)
    }
}