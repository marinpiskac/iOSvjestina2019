//
//  Quiz+CoreDataProperties.swift
//  ruazosi
//
//  Created by Marin Piskac on 16/06/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//
//

import Foundation
import CoreData


extension Quiz {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quiz> {
        return NSFetchRequest<Quiz>(entityName: "Quiz")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var quizDescription: String?
    @NSManaged public var category: String?
    @NSManaged public var level: Int32
    @NSManaged public var image: String?
    @NSManaged public var questions: NSOrderedSet

    var enumCategory: QuizType {
        get {
            return QuizType(text: category ?? "")
        }
        set {
            self.category = newValue.rawValue
        }
    }
}

// MARK: Generated accessors for questions
extension Quiz {

    @objc(insertObject:inQuestionsAtIndex:)
    @NSManaged public func insertIntoQuestions(_ value: Question, at idx: Int)

    @objc(removeObjectFromQuestionsAtIndex:)
    @NSManaged public func removeFromQuestions(at idx: Int)

    @objc(insertQuestions:atIndexes:)
    @NSManaged public func insertIntoQuestions(_ values: [Question], at indexes: NSIndexSet)

    @objc(removeQuestionsAtIndexes:)
    @NSManaged public func removeFromQuestions(at indexes: NSIndexSet)

    @objc(replaceObjectInQuestionsAtIndex:withObject:)
    @NSManaged public func replaceQuestions(at idx: Int, with value: Question)

    @objc(replaceQuestionsAtIndexes:withQuestions:)
    @NSManaged public func replaceQuestions(at indexes: NSIndexSet, with values: [Question])

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: Question)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: Question)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSOrderedSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSOrderedSet)

}
