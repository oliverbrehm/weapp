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
        
        let postData = "\(Arguments.Action)=\(Action.User.Register)&" +
                "\(Arguments.User.Mail)=\(mail)&" +
                "\(Arguments.User.Password)=\(password)&" +
                "\(Arguments.User.FirstName)=\(firstName)&" +
                "\(Arguments.User.LastName)=\(lastName)&" +
                "\(Arguments.User.UserType)=\(userType)&" +
                "\(Arguments.User.Gender)=\(gender)&" +
                "\(Arguments.User.DateOfBirth)=\(birthDateString)&" +
                "\(Arguments.User.Nationality)=\(nationality)&" +
                "\(Arguments.User.DateOfImmigration)=\(immigrationDateString)&" +
                "\(Arguments.User.LocationLatitude)=\(locationLatitude)&" +
                "\(Arguments.User.LocationLongitude)=\(locationLongitude)&"
        
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
