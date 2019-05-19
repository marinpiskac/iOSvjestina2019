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

        delegate.window?.rootViewController =
                UINavigationController(rootViewController: QuizListViewControler(quizService: delegate.quizService,
                                                                                 router: self)
                )
    }

    func resetToLoginScreen() {
        guard let delegate = delegate else { return }

        delegate.window?.rootViewController = LoginViewController(authService: delegate.authService, router: self)
    }

    func pushQuizView(quiz: Quiz) {
        if (delegate?.window?.rootViewController != nil && delegate!.window!.rootViewController as? UINavigationController != nil) {
            (delegate?.window?.rootViewController as! UINavigationController)
                    .pushViewController(QuizViewController(quiz: quiz, quizService: delegate!.quizService, router: self), animated: true)
        }
    }

    func popCurrentView(){
        if (delegate?.window?.rootViewController != nil && delegate!.window!.rootViewController as? UINavigationController != nil) {
            (delegate?.window?.rootViewController as! UINavigationController)
                    .popViewController(animated: true)
        }
    }
}