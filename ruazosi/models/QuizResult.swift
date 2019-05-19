//
// Created by Marin Piskac on 2019-05-19.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import Foundation

class QuizResult {
    let quizId: Int
    let userId: Int
    let time: Float
    let noOfCorrect: Int

    init(_ quizId: Int, _ userId: Int,_ time: Float, _ noOfCorrect: Int){
        self.quizId = quizId
        self.userId = userId
        self.time = time
        self.noOfCorrect = noOfCorrect
    }
}