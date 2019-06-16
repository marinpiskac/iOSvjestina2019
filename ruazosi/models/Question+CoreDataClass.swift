//
//  Question+CoreDataClass.swift
//  ruazosi
//
//  Created by Marin Piskac on 16/06/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Question)
public class Question: NSManagedObject {

    class func firstOrCreate(withId id: Int32) -> Question? {
        let context = DataController.shared.persistentContainer.viewContext

        let request: NSFetchRequest<Question> = Question.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id.description)
        request.returnsObjectsAsFaults = false

        do {
            let questions = try context.fetch(request)
            if let question = questions.first {
                return question
            } else {
                let newQuestion = Question(context: context)
                return newQuestion
            }
        } catch {
            return nil
        }
    }

    class func fromJson(json: Any) -> Question? {
        if let jsonDict = json as? Dictionary<String, Any>,
           let id = jsonDict["id"] as? Int,
           let questionText = jsonDict["question"] as? String,
           let answers = jsonDict["answers"] as? [String],
           let correctAnswer = jsonDict["correct_answer"] as? Int,
           let question = firstOrCreate(withId: Int32(id)) {
            question.id = Int32(id)
            question.question = questionText
            question.answers = answers
            question.correctAnswer = Int32(correctAnswer)
            do {
                let context = DataController.shared.persistentContainer.viewContext
                try context.save()
                return question
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
