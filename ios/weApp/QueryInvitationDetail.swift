//
//  QueryInvitationDetail.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryInvitationDetail: Query
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
        
    open func send(_ id: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.Invitation.Details)&\(Arguments.Invitation.InvitationId)=\(id)"
        super.sendHTTPPost(data: postData, completion: completion)
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
