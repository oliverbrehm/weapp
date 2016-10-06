//
//  QueryUserRegister.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryUserRegister: Query
{
    open var userId = ""
    open func send(_ mail: String, password: String, firstName: String, lastName: String,
                   userType: Bool, gender: Bool,
                   dateOfBirth: Date, nationality: String,
                   dateOfImmigration: Date,
                   locationLatitude: Int, locationLongitude: Int, completion: @escaping ((Bool) -> Void))
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let immigrationDateString = dateFormatter.string(from: dateOfImmigration)
        let birthDateString = dateFormatter.string(from: dateOfBirth)
        
        let postData =
            "action=user_register&" +
                
                "mail=\(mail)&" +
                "password=\(password)&" +
                "firstName=\(firstName)&" +
                "lastName=\(lastName)&" +
                "userType=\(userType)&" +
                "gender=\(gender)&" +
                "dateOfBirth=\(birthDateString)&" +
                "nationality=\(nationality)&" +
                "dateOfImmigration=\(immigrationDateString)&" +
                "locationLatitude=\(locationLatitude)&" +
        "locationLongitude=\(locationLongitude)&"
        
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
