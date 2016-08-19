//
//  JoinRequest.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 23.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

public class JoinRequest
{
    let requestId: Int
    let userId: Int
    let invitationId: Int
    let numParticipants: Int
    let maxParticipants: Int
    let invitationName: String
    
    init(requestId: Int, userId: Int, invitationId: Int, numParticipants: Int, maxParticipants: Int, invitationName: String) {
        self.requestId = requestId
        self.userId = userId
        self.invitationId = invitationId
        self.numParticipants = numParticipants
        self.maxParticipants = maxParticipants
        self.invitationName = invitationName
    }
}

public class HTTPJoinRequestListRequest: HTTPRequest
{
    private var currentRequestId = ""
    private var currentRequestInvitationId = ""
    private var currentRequestUserId = ""
    private var currentRequestNumParticipants = ""
    private var currentRequestMaxParticipants = ""
    private var currentRequestInvitationName = ""

    
    public var joinRequests: [JoinRequest] = []
    
    public func send() -> Bool
    {
        let postData = "action=joinRequest_query"
        return super.sendPost(postData)
    }
    
    public func send(user: User) -> Bool
    {
        let postData = "action=joinRequest_query&userID=\(user.id)"
        return super.sendPost(postData)
    }
    
    public override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        switch(elementName) {
        case "id":
            self.currentRequestId = self.currentString
            break
        case "userId":
            self.currentRequestUserId = self.currentString
            break
        case "invitationId":
            self.currentRequestInvitationId = self.currentString
            break
        case "numParticipants":
            self.currentRequestNumParticipants = self.currentString
            break;
        case "maxParticipants":
            self.currentRequestMaxParticipants = self.currentString
            break;
        case "invitationName":
            self.currentRequestInvitationName = self.currentString
            break;
        case "JoinRequest":
            self.joinRequests.append(JoinRequest(requestId: Int(currentRequestId)!, userId: Int(currentRequestUserId)!, invitationId: Int(currentRequestInvitationId)!, numParticipants: Int(currentRequestNumParticipants)!, maxParticipants: Int(currentRequestMaxParticipants)!, invitationName: currentRequestInvitationName))
            break
            
        default: break
        }
    }
}

public class HTTPJoinRequestAccept: HTTPRequest
{
    public func send(requestId: Int) -> Bool
    {
        let postData = "action=joinRequest_accept&id=\(requestId)"
        return super.sendPost(postData)
    }
}

public class HTTPJoinRequestReject: HTTPRequest
{
    public func send(requestId: Int) -> Bool
    {
        let postData = "action=joinRequest_reject&id=\(requestId)"
        return super.sendPost(postData)
    }
}