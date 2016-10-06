//
//  QueryJoinRequestList.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation


open class QueryJoinRequestList: Query
{
    fileprivate var currentRequestId = ""
    fileprivate var currentRequestInvitationId = ""
    fileprivate var currentRequestUserId = ""
    fileprivate var currentRequestNumParticipants = ""
    fileprivate var currentRequestMaxParticipants = ""
    fileprivate var currentRequestInvitationName = ""
    fileprivate var currentRequestUserName = ""
    
    open var joinRequests: [JoinRequest] = []
    
    open func send(completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=joinRequest_query"
        super.sendHTTPPost(data: postData, completion: completion)
    }
    
    open func send(_ user: User, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=joinRequest_query&userID=\(user.id)"
        super.sendHTTPPost(data: postData, completion: completion)
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
        case "userName": // TODO not yet sent by server
            self.currentRequestUserName = self.currentString
            break;
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
            self.joinRequests.append(JoinRequest(requestId: Int(currentRequestId)!, requestingUserId: Int(currentRequestUserId)!, requestingUserFirstName: "", invitationId: Int(currentRequestInvitationId)!, numParticipants: Int(currentRequestNumParticipants)!, maxParticipants: Int(currentRequestMaxParticipants)!, invitationName: currentRequestInvitationName))
            break
            
        default: break
        }
    }
}
