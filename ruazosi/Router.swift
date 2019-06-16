//
// Created by Marin Piskac on 2019-05-19.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import Foundation
import UIKit

class Router {
    private weak var delegate: AppDelegate?

    init(delegate: AppDelegate) {
        self.delegate = delegate
    }

    func resetToQuizzesScreen() {
        guard let delegate = delegate else { return }

        let quizListVC = UINavigationController(rootViewController: QuizListViewControler(quizService: delegate.quizService,
                                                                                          router: self)
        )
        quizListVC.tabBarItem = UITabBarItem(title: "Quizzes", image: .none, tag: 0)

        let searchVC = UINavigationController(rootViewController: SearchViewController(router: self))
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: .none, tag: 1)

        let settingsVC = UINavigationController(rootViewController: SettingsViewController(
                persistenceService: delegate.persistenceService,
                router: self
        ))
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: .none, tag: 2)

        let homeTabBarController = UITabBarController()
        homeTabBarController.tabBar.isTranslucent = false
        homeTabBarController.viewControllers = [quizListVC, searchVC, settingsVC]

        delegate.window?.rootViewController = homeTabBarController
    }

    func resetToLoginScreen() {
        guard let delegate = delegate else { return }

        delegate.window?.rootViewController = LoginViewController(authService: delegate.authService, router: self)
    }

    func pushQuizView(quiz: Quiz) {
        if (delegate?.window?.rootViewController != nil
                    && delegate!.window!.rootViewController as? UITabBarController != nil
                    && (delegate!.window?.rootViewController as! UITabBarController).selectedViewController as? UINavigationController != nil) {
            ((delegate?.window?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController)
                    .pushViewController(QuizViewController(quiz: quiz, quizService: delegate!.quizService, router: self), animated: true)
        }
    }

    func pushLeaderboardView(quizId: Int) {
        if (delegate?.window?.rootViewController != nil
                    && delegate!.window!.rootViewController as? UITabBarController != nil
                    && (delegate!.window?.rootViewController as! UITabBarController).selectedViewController as? UINavigationController != nil) {
            ((delegate?.window?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController)
                    .pushViewController(LeaderboardViewController(quizService: delegate!.quizService, quizId: quizId), animated: true)
        }
    }

    func popCurrentView() {
        if (delegate?.window?.rootViewController != nil
                    && delegate!.window!.rootViewController as? UITabBarController != nil
                    && (delegate!.window?.rootViewController as! UITabBarController).selectedViewController as? UINavigationController != nil) {
            ((delegate?.window?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController)
                    .popViewController(animated: true)
        }
    }
}