//
// Created by Marin Piskac on 2019-05-19.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import Foundation

class AuthDetails {
    let token: String
    let userId: Int
    var username: String = ""

    init?(json: Any) {
        if let jsonDict = json as? Dictionary<String, Any>,
           let token = jsonDict["token"] as? String,
           let userId = jsonDict["user_id"] as? Int {
            self.token = token
            self.userId = userId
        } else {
            return nil
        }
    }

    init(token: String, userId: Int){
        self.token = token
        self.userId = userId
    }

    init(token: String, userId: Int, username: String){
        self.token = token
        self.userId = userId
        self.username = username
    }
}