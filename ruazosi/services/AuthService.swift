//
// Created by Marin Piskac on 2019-05-19.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import Foundation

class AuthService {
    let persistenceService: PersistenceService

    init(persistenceService: PersistenceService){
        self.persistenceService = persistenceService
    }

    func logIn(_ username: String?, _ password: String?, _ completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/session?username=" + username.unsafelyUnwrapped + "&password=" + password.unsafelyUnwrapped) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let authDetails = AuthDetails(json: json){
                        authDetails.username = username ?? ""
                        self.persistenceService.saveAuthData(authDetails)
                        completion(true)
                    }else{
                        completion(false)
                    }
                } catch {}
            }
        }

        dataTask.resume()
    }
}