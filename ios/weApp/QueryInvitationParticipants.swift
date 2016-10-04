//
//  QueryInvitationParticipants.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryInvitationParticipants: Query
{
    fileprivate var currentUserId = ""
    fileprivate var currentFirstName = ""
    fileprivate var currentNumParticipants = ""
    
    open var participants: [User] = []
    
    open func send(completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_query"
        super.sendHTTPPost(data: postData, completion: completion)
    }
    
    open func send(_ invitationId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_get_participants&id=\(invitationId)"
        super.sendHTTPPost(data: postData, completion: completion)
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
            self.participants.append(User(id: Int(self.currentUserId)!, firstName: self.currentFirstName))
            break
            
        default: break
        }
    }
}
