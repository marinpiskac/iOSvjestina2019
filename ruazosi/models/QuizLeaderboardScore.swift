//
// Created by Marin Piskac on 2019-06-16.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import Foundation

class QuizLeaderboardScore {
    let userId: String
    let score: Double

    init?(json: Any) {
        if let jsonDict = json as? Dictionary<String, Any>,
           let userId = jsonDict["username"] as? String,
           let score = jsonDict["score"] as? String {
            self.userId = userId
            self.score = Double(score) ?? 0
        } else {
            return nil
        }
    }
}
