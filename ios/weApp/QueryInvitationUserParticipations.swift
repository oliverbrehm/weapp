//
//  QueryInvitationParticipatioinList.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryInvitationUserParticipations: Query
{
    fileprivate var currentInvitationID = ""
    fileprivate var currentInvitationName = ""
    
    open var invitations: [Invitation] = []
    
    open func send(_ user: User, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_query_participating&userId=\(user.id)"
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
