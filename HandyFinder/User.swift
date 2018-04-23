//
//  User.swift
//  HandyFinder
//
//  Created by Haki Dehari on 2/24/18.
//  Copyright © 2018 EpochApps. All rights reserved.
//

import Foundation

struct User {
    
    var firstName: String
    var lastName: String
    var email: String
    var state: String
    var city: String
    var password: String
    var password2: String
    var zipCode: String
    var isHMan: String
    var skills: String
    var experience: String
    
    init(firstName: String, lastName: String, email: String, state: String, city: String, password: String, password2: String, zipCode: String, isHMan: String, skills: String, experience: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.state = state
        self.city = city
        self.password = password
        self.password2 = password2
        self.zipCode = zipCode
        self.isHMan = isHMan
        self.skills = skills
        self.experience = experience
    }
    
    init() {
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.state = ""
        self.city = ""
        self.password = ""
        self.password2 = ""
        self.zipCode = ""
        self.isHMan = ""
        self.skills = ""
        self.experience = ""
    }
    
}
