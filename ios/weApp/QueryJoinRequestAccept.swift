//
//  QueryJoinRequestAccept.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryJoinRequestAccept: Query
{
    open func send(_ requestId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=joinRequest_accept&id=\(requestId)"
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
