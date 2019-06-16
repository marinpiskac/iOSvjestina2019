//
//  Question+CoreDataProperties.swift
//  ruazosi
//
//  Created by Marin Piskac on 16/06/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var id: Int32
    @NSManaged public var question: String
    @NSManaged public var answers: [String]
    @NSManaged public var correctAnswer: Int32

}
