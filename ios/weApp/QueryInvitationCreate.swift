//
//  QueryInvitationCreate.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryInvitationCreate: Query
{
    open func send(_ name : String, detailedDescription : String,
                   maxParticipants : Int, date: String, time: String,
                   locationCity : String, locationStreet : String, locationStreetNumber : Int,
                   locationLatitude : Int, locationLongitude : Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.Invitation.Create)" +
            "&\(Arguments.Invitation.Name)=\(name)" +
            "&\(Arguments.Invitation.Description)=\(detailedDescription)" +
            "&\(Arguments.Invitation.MaxParticipants)=\(maxParticipants)" +
            "&\(Arguments.Invitation.Date)=\(date)" +
            "&\(Arguments.Invitation.Time)=\(time)" +
            "&\(Arguments.Invitation.LocationCity)=\(locationCity)" +
            "&\(Arguments.Invitation.LocationStreet)=\(locationStreet)" +
            "&\(Arguments.Invitation.LocationStreetNumber)=\(locationStreetNumber)" +
            "&\(Arguments.Invitation.LocationLatitude)=\(locationLatitude)" +
            "&\(Arguments.Invitation.LocationLongitude)=\(locationLongitude)"
        
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
