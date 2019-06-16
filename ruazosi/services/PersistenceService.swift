//
// Created by Marin Piskac on 2019-05-19.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import Foundation

class PersistenceService {
    private let USER_ID_KEY = "user_id"
    private let TOKEN_KEY = "token"
    private let USERNAME_KEY = "username"

    func saveAuthData(_ data: AuthDetails) {
        UserDefaults.standard.set(data.token, forKey: TOKEN_KEY)
        UserDefaults.standard.set(data.userId, forKey: USER_ID_KEY)
        UserDefaults.standard.set(data.username, forKey: USERNAME_KEY)
    }

    func getAuthData() -> AuthDetails? {
        if let userIdStr = UserDefaults.standard.string(forKey: USER_ID_KEY),
           let token = UserDefaults.standard.string(forKey: TOKEN_KEY),
           let username = UserDefaults.standard.string(forKey: USERNAME_KEY),
           let userId = Int(userIdStr) {
            return AuthDetails(token: token, userId: userId, username: username)
        }else{
            return nil
        }
    }

    func deleteAuthData(){
        UserDefaults.standard.removeObject(forKey: TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: USER_ID_KEY)
        UserDefaults.standard.removeObject(forKey: USERNAME_KEY)
    }
}
