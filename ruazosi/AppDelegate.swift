//
//  AppDelegate.swift
//  ruazosi
//
//  Created by Marin Piskac on 2019-04-01.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let persistenceService = PersistenceService()

    let quizService: QuizService!

    var authService: AuthService!

    var router: Router?

    override init() {
        self.authService = AuthService(persistenceService: persistenceService)
        self.quizService = QuizService(persistenceService: persistenceService)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        self.router = Router(delegate: self)

        persistenceService.getAuthData() == nil ? router?.resetToLoginScreen() : router?.resetToQuizzesScreen()

        window?.makeKeyAndVisible()

        return true
    }
}
