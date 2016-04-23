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

public class HTTPInvitationListRequest: HTTPRequest
{
    private var currentInvitationID = ""
    private var currentInvitationName = ""
    
    public var invitations: [InvitationHeader] = []
    
    public func send() -> Bool
    {
        let postData = "action=invitation_query"
        return super.sendPost(postData)
    }
    
    public func send(user: User) -> Bool
    {
        let postData = "action=invitation_query&userID=\(user.id)"
        return super.sendPost(postData)
    }
    
    public override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
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

public class HTTPInvitationCreateRequest: HTTPRequest
{
    public var invitations: [InvitationHeader] = []
    
    public func send(name : String, detailedDescription : String,
                     maxParticipants : Int, date: String, time: String,
                     locationCity : String, locationStreet : String, locationStreetNumber : Int,
                     locationLatitude : Int, locationLongitude : Int) -> Bool
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
        
        return super.sendPost(postData)
    }
}

public class HTTPInvitationJoinRequest: HTTPRequest
{
    public var invitations: [InvitationHeader] = []
    
    public func send(invitationId: Int, userId: Int, numParticipants: Int) -> Bool
    {
        let postData = "action=invitation_join_request" +
            "&id=\(invitationId)" +
            "&userId=\(userId)" +
            "&numParticipants=\(numParticipants)"
        
        return super.sendPost(postData)
    }
}

public class HTTPInvitationDetailRequest: HTTPRequest
{
    public var invitationId: String = ""
    public var name: String = ""
    public var ownerId: String = ""
    public var ownerName: String = ""
    public var invitationDescription: String = ""
    public var maxParticipants: String = ""
    public var date: String = ""
    public var time: String = ""
    public var locationCity: String = ""
    public var locationStreet: String = ""
    public var locationStreetNumber: String = ""
    public var locationLatitude: String = ""
    public var locationLongitude: String = ""
    
    public var invitations: [InvitationHeader] = []
    
    public func send(id: Int) -> Bool
    {
        let postData = "action=invitation_get_details&id=\(id)"
        return super.sendPost(postData)
    }
    
    public override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
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
        case "OwnerName":
            self.ownerName = self.currentString
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