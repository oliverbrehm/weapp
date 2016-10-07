//
//  QueryJoinRequestReject.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryJoinRequestReject: Query
{
    open func send(_ requestId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.JoinRequest.Reject)&\(Arguments.JoinRequest.JoinRequestId)=\(requestId)"
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
