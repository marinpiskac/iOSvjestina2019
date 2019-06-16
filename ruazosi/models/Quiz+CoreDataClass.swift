//
//  Quiz+CoreDataClass.swift
//  ruazosi
//
//  Created by Marin Piskac on 16/06/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Quiz)
public class Quiz: NSManagedObject {

    class func firstOrCreate(withId id: Int32) -> Quiz? {
        let context = DataController.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id.description)
        request.returnsObjectsAsFaults = false

        do {
            let quizzes = try context.fetch(request)
            if let quiz = quizzes.first {
                return quiz
            } else {
                let newQuiz = Quiz(context: context)
                return newQuiz
            }
        } catch {
            return nil
        }
    }

    class func fromJson(json: Any) -> Quiz? {
        if let jsonDict = json as? Dictionary<String, Any>,
           let id = jsonDict["id"] as? Int,
           let title = jsonDict["title"] as? String,
           let description = jsonDict["description"],
           let category = jsonDict["category"] as? String,
           let level = jsonDict["level"] as? Int,
           let image = jsonDict["image"],
           let questions = jsonDict["questions"] as? [Any],
           let quiz = firstOrCreate(withId: Int32(id)) {
            quiz.id = Int32(id)
            quiz.title = title
            quiz.quizDescription = description as? String
            quiz.enumCategory = QuizType(text: category)
            quiz.level = Int32(level)
            quiz.image = image as? String
            quiz.questions = NSOrderedSet(array: questions.compactMap { questionJson in return Question.fromJson(json: questionJson) })
            do {
                let context = DataController.shared.persistentContainer.viewContext
                try context.save()
                return quiz
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
