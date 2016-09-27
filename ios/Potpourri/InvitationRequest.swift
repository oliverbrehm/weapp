//
//  InvitationRequest.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 13.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

public struct InvitationHeader
{
    public let id: String
    public let name: String
    
    init(id: String, name: String)
    {
        self.id = id
        self.name = name
    }
}

open class HTTPInvitationListRequest: HTTPRequest
{
    fileprivate var currentInvitationID = ""
    fileprivate var currentInvitationName = ""
    
    open var invitations: [InvitationHeader] = []
    
    open func send(completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_query"
        super.sendPost(postData, completion: completion)
    }
    
    open func send(_ user: User, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_query&userID=\(user.id)"
        super.sendPost(postData, completion: completion)
    }
    
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        switch(elementName) {
        case "id":
            self.currentInvitationID = self.currentString
            break
        case "name":
            self.currentInvitationName = self.currentString
            break
        case "invitation":
            self.invitations.append(InvitationHeader(id: self.currentInvitationID, name: self.currentInvitationName))
            break
            
        default: break
        }
    }
}

open class HTTPInvitationParticipatingListRequest: HTTPRequest
{
    fileprivate var currentInvitationID = ""
    fileprivate var currentInvitationName = ""
    
    open var invitations: [InvitationHeader] = []
    
    open func send(_ user: User, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_query_participating&userId=\(user.id)"
        super.sendPost(postData, completion: completion)
    }
    
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        switch(elementName) {
        case "id":
            self.currentInvitationID = self.currentString
            break
        case "name":
            self.currentInvitationName = self.currentString
            break
        case "invitation":
            self.invitations.append(InvitationHeader(id: self.currentInvitationID, name: self.currentInvitationName))
            break
            
        default: break
        }
    }
}

open class HTTPInvitationCreateRequest: HTTPRequest
{
    open var invitations: [InvitationHeader] = []
    
    open func send(_ name : String, detailedDescription : String,
                     maxParticipants : Int, date: String, time: String,
                     locationCity : String, locationStreet : String, locationStreetNumber : Int,
                     locationLatitude : Int, locationLongitude : Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_create" +
            "&name=\(name)" +
            "&description=\(detailedDescription)" +
            "&maxParticipants=\(maxParticipants)" +
            "&date=\(date)" +
            "&time=\(time)" +
            "&locationCity=\(locationCity)" +
            "&locationStreet=\(locationStreet)" +
            "&locationStreetNumber=\(locationStreetNumber)" +
            "&locationLatitude=\(locationLatitude)" +
            "&locationLongitude=\(locationLongitude)"
        
        super.sendPost(postData, completion: completion)
    }
}

open class HTTPInvitationJoinRequest: HTTPRequest
{
    open var invitations: [InvitationHeader] = []
    
    open func send(_ invitationId: Int, userId: Int, numParticipants: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_join_request" +
            "&id=\(invitationId)" +
            "&userId=\(userId)" +
            "&numParticipants=\(numParticipants)"
        
        super.sendPost(postData, completion: completion)
    }
}

open class HTTPInvitationGetParticipantsRequest: HTTPRequest
{
    fileprivate var currentUserId = ""
    fileprivate var currentFirstName = ""
    fileprivate var currentNumParticipants = ""

    open var participants: [Participant] = []
    
    open func send(completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_query"
        super.sendPost(postData, completion: completion)
    }
    
    open func send(_ invitationId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_get_participants&id=\(invitationId)"
        super.sendPost(postData, completion: completion)
    }
    
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        switch(elementName) {
        case "userId":
            self.currentUserId = self.currentString
            break
        case "firstName":
            self.currentFirstName = self.currentString
            break
        case "numParticipants":
            self.currentNumParticipants = self.currentString
            break
        case "Participant":
            self.participants.append(Participant(userId: Int(self.currentUserId)!, firstName: self.currentFirstName, numPersons: Int(self.currentNumParticipants)!))
            break
            
        default: break
        }
    }
}

open class HTTPInvitationDetailRequest: HTTPRequest
{
    open var invitationId: String = ""
    open var name: String = ""
    open var ownerId: String = ""
    open var ownerFirstName: String = ""
    open var ownerLastName: String = ""
    open var invitationDescription: String = ""
    open var maxParticipants: String = ""
    open var date: String = ""
    open var time: String = ""
    open var locationCity: String = ""
    open var locationStreet: String = ""
    open var locationStreetNumber: String = ""
    open var locationLatitude: String = ""
    open var locationLongitude: String = ""
    
    open var invitations: [InvitationHeader] = []
    
    open func send(_ id: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_get_details&id=\(id)"
        super.sendPost(postData, completion: completion)
    }
    
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        switch(elementName) {
        case "InvitationId":
            self.invitationId = self.currentString
            break
        case "Name":
            self.name = self.currentString
            break
        case "OwnerId":
            self.ownerId = self.currentString
            break
        case "OwnerFirstName":
            self.ownerFirstName = self.currentString
            break
        case "OwnerLastName":
            self.ownerLastName = self.currentString
            break
        case "Description":
            self.invitationDescription = self.currentString
            break
        case "MaxParticipants":
            self.maxParticipants = self.currentString
            break
        case "Date":
            self.date = self.currentString
            break
        case "Time":
            self.time = self.currentString
            break
        case "LocationCity":
            self.locationCity = self.currentString
            break
        case "LocationStreet":
            self.locationStreet = self.currentString
            break
        case "LocationStreetNumber":
            self.locationStreetNumber = self.currentString
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
