//
//  User.swift
//  FoodRecipes
//
//  Created by CNTT on 5/23/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit

class User{
    var userID:String
    var userName:String
    var fullName:String
    var image:String
    var dateOfBirth:String
    var email:String
    var phoneNumber:String
    var gender:String
    var password:String
    
    init(userID: String, userName:String, fullName:String, image:String, dateOfBirth:String, email:String, phoneNumber:String, gender:String, password:String) {
        self.userID = userID
        self.userName = userName
        self.fullName = fullName
        self.image = image
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.password = password
    }
}
