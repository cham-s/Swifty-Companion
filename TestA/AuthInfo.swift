//
//  ClientSession.swift
//  TestA
//
//  Created by gecko on 22/08/16.
//  Copyright © 2016 Chamsidine ATTOUMANI. All rights reserved.
//

import Foundation


struct ClientSession {
    var uid = ""
    var secret = ""
    var authURL = ""
}

class AuthInfo {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    var scope: String
    var createdAt: Int
    
    init () {
        accessToken = ""
        tokenType = ""
        expiresIn = 0
        scope =  ""
        createdAt = 0
    }
}