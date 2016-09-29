//
//  InvitationMessageRequest.swift
//  Potpourri
//
//  Created by Oliver Brehm on 29.09.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class HTTPPostMessageRequest: HTTPRequest
{
    open func send(invitationId: Int, message: String, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_post_comment&id=\(invitationId)&comment=\(message)"
        super.sendPost(postData, completion: completion)
    }
}

open class HTTPPMessageListRequest: HTTPRequest
{    
    fileprivate var currentMessage = ""
    fileprivate var currentOwnerId = ""
    fileprivate var currentOwnerName = ""
    fileprivate var currentTime = ""
 
    open var messages: [Message] = []
    
    open func send(invitationId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_get_comments&id=\(invitationId)"
        super.sendPost(postData, completion: completion)
    }
    
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        

        switch(elementName) {
        case "message":
            self.currentMessage = self.currentString
            break
        case "authorId":
            self.currentOwnerId = self.currentString
            break
        case "authorName":
            self.currentOwnerName = self.currentString
            break
        case "time":
            self.currentTime = self.currentString
            break;

        case "comment":
            // TODO move to other place
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let d = dateFormatter.date(from: self.currentTime)
            let date : Date
            if(d != nil) {
                date = d!
            } else {
                date = Date.distantPast
            }
        
            self.messages.append(Message(text: currentMessage, ownerId: Int(currentOwnerId)!, ownerName: currentOwnerName, time: date))
            break
            
        default: break
        }
    }
}

