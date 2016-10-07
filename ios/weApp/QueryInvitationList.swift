//
//  InvitationRequest.swift
//  weApp
//
//  Created by Oliver Brehm on 13.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryInvitationList: Query
{
    fileprivate var currentInvitationID = ""
    fileprivate var currentInvitationName = ""
    
    open var invitations: [Invitation] = []
   
    open func send(completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.Invitation.Query)"
        super.sendHTTPPost(data: postData, completion: completion)
    }
    
    open func send(owner: User, completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.Invitation.Query)&\(Arguments.Invitation.OwnerId)=\(owner.id)"
        super.sendHTTPPost(data: postData, completion: completion)
    }
    
    open func send(participatingUser: User, completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.Invitation.Query)&\(Arguments.Invitation.ParticipatingUserId)=\(participatingUser.id)"
        super.sendHTTPPost(data: postData, completion: completion)
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
            self.invitations.append(Invitation(invitationId: Int(self.currentInvitationID)!, name: self.currentInvitationName))
            break
            
        default: break
        }
    }
}
