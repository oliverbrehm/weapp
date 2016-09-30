//
//  JoinRequest.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 23.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class JoinRequest
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

open class JoinRequestList
{
    public let user: User
    
    init(for user: User) {
        self.user = user
    }
    
    private var joinRequests: [JoinRequest] = []
    
    func isEmpty() -> Bool
    {
        return self.joinRequests.count == 0
    }
    
    func count() -> Int
    {
        return self.joinRequests.count
    }
    
    func joinRequest(index: Int) -> JoinRequest
    {
        return self.joinRequests[index]
    }
    
    func fetch(max: Int, completion: @escaping ((Bool) -> Void))
    {
        let request = HTTPJoinRequestListRequest()
        
        let user = User.current
        if(user == nil) {
            completion(false)
            return
        }
        
        request.send(user!) { (success: Bool) in
            
            if(request.responseValue == false) {
                completion(false)
                return
            }
        
            self.joinRequests.append(contentsOf: request.joinRequests)
            
            completion(true)
        }
    }
}

open class HTTPJoinRequestListRequest: HTTPRequest
{
    fileprivate var currentRequestId = ""
    fileprivate var currentRequestInvitationId = ""
    fileprivate var currentRequestUserId = ""
    fileprivate var currentRequestNumParticipants = ""
    fileprivate var currentRequestMaxParticipants = ""
    fileprivate var currentRequestInvitationName = ""

    
    open var joinRequests: [JoinRequest] = []
    
    open func send(completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=joinRequest_query"
        super.sendPost(postData, completion: completion)
    }
    
    open func send(_ user: User, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=joinRequest_query&userID=\(user.id)"
        super.sendPost(postData, completion: completion)
    }
    
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
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

open class HTTPJoinRequestAccept: HTTPRequest
{
    open func send(_ requestId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=joinRequest_accept&id=\(requestId)"
        super.sendPost(postData, completion: completion)
    }
}

open class HTTPJoinRequestReject: HTTPRequest
{
    open func send(_ requestId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=joinRequest_reject&id=\(requestId)"
        super.sendPost(postData, completion: completion)
    }
}
