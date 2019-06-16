////
////  Quiz.swift
////  ruazosi
////
////  Created by Marin Piskac on 01/04/2019.
////  Copyright © 2019 Marin Piskač. All rights reserved.
////
//
//import Foundation
//
//class Quiz {
//    let id: Int
//    let title: String
//    let description: String?
//    let category: QuizType
//    let level: Int
//    let image: String?
//    let questions: [Question]
//
//    init?(json: Any) {
//        if let jsonDict = json as? Dictionary<String, Any>,
//           let id = jsonDict["id"] as? Int,
//           let title = jsonDict["title"] as? String,
//           let description = jsonDict["description"],
//           let category = jsonDict["category"] as? String,
//           let level = jsonDict["level"] as? Int,
//           let image = jsonDict["image"],
//           let questions = jsonDict["questions"] as? [Any] {
//            self.id = id
//            self.title = title
//            self.description = description as? String
//            self.category = QuizType(text: category)
//            self.level = level
//            self.image = image as? String
//            self.questions = questions.compactMap { questionJson in
//                return Question(json: questionJson)
//            }
//        } else {
//            return nil
//        }
//    }
//}
