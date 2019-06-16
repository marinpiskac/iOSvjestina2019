//
// Created by Marin Piskac on 2019-06-16.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    static let shared = DataController()

    private init() {} // Prevent clients from creating another instance.

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func fetchQuizzes() -> [Quiz]{
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let context = DataController.shared.persistentContainer.viewContext
        let quizzes = try? context.fetch(request)
        return quizzes ?? []
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
