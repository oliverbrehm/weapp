//
//  QueryUserLogout.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryUserLogout: Query
{
    open var userId = ""
    open func send(completion: @escaping ((Bool) -> Void))    {
        let postData = "\(Arguments.Action)=\(Action.User.Logout)"
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
