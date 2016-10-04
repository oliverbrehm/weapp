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
        let postData = "action=invitation_create" +
            "&name=\(name)" +
            "&description=\(detailedDescription)" +
            "&maxParticipants=\(maxParticipants)" +
            "&date=\(date)" +
            "&time=\(time)" +
            "&locationCity=\(locationCity)" +
            "&locationStreet=\(locationStreet)" +
            "&locationStreetNumber=\(locationStreetNumber)" +
            "&locationLatitude=\(locationLatitude)" +
        "&locationLongitude=\(locationLongitude)"
        
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
