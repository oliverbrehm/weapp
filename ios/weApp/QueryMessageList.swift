//
//  QueryMessageList.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryMessageList: Query
{
    fileprivate var currentMessage = ""
    fileprivate var currentOwnerId = ""
    fileprivate var currentOwnerName = ""
    fileprivate var currentTime = ""
    fileprivate var currentId = "0"
    
    fileprivate let dateFormatter : DateFormatter
    
    open var messages: [Message] = []
    
    override init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    open func send(invitationId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.Invitation.Messages)&\(Arguments.Invitation.InvitationId)=\(invitationId)"
        
        super.sendHTTPPost(data: postData, completion: completion)
    }
    
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        
        switch(elementName) {
        case "id": // TODO not sent yet by server
            self.currentId = self.currentString
            break
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
            var date = self.dateFormatter.date(from: self.currentTime)
            if(date == nil) {
                date = Date.distantPast
            }
            
            self.messages.append(Message(id: Int(currentId)!, text: currentMessage, ownerId: Int(currentOwnerId)!, ownerName: currentOwnerName, time: date!))
            break
            
        default: break
        }
    }
}
