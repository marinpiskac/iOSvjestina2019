//
//  LoginViewController.swift
//  ruazosi
//
//  Created by Marin Piskac on 15/05/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import UIKit
import PureLayout

class LoginViewController: UIViewController {

    var loginLabel: UILabel!
    var usernameLabel: UILabel!
    var usernameInput: UITextField!
    var passwordLabel: UILabel!
    var passwordInput: UITextField!
    var loginButton: UIButton!
    var loginErrorLabel: UILabel!

    var loginButtonConstraint: NSLayoutConstraint!
    var appTitleLabelConstraint: NSLayoutConstraint!

    var authService: AuthService?
    var router: Router?

    convenience init(authService: AuthService, router: Router) {
        self.init()
        self.authService = authService
        self.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.animateViewsIn()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func onLoginPressed() {
        authService?.logIn(usernameInput.text, passwordInput.text, { success in
            DispatchQueue.main.async {
                if (success) {
                    self.animateViewsOut() {
                        self.router?.resetToQuizzesScreen()
                    }
                } else {
                    self.loginErrorLabel.isHidden = false
                }
            }
        })
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            loginButtonConstraint.constant = -keyboardHeight - 14
        } else {
            loginButtonConstraint.constant = -360
        }
        appTitleLabelConstraint.constant = 16
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        appTitleLabelConstraint.constant = 195
        loginButtonConstraint.constant = -8
    }

    func animateViewsIn() {
        self.loginButton.transform = CGAffineTransform(translationX: -300, y: 0)
        UIView.animate(withDuration: 1) {
            self.loginLabel.layer.anchorPoint = CGPoint(x: 0.2, y: 0.5)
            self.loginLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.loginLabel.alpha = 1
        }

        UIView.animate(withDuration: 1) {
            self.usernameLabel.transform = CGAffineTransform(translationX: 250, y: 0)
            self.usernameInput.transform = CGAffineTransform(translationX: 250, y: 0)
        }

        UIView.animate(withDuration: 1, delay: 0.3, animations: {
            self.passwordLabel.transform = CGAffineTransform(translationX: 250, y: 0)
            self.passwordInput.transform = CGAffineTransform(translationX: 250, y: 0)
        }) { _ in }

        UIView.animate(withDuration: 1, delay: 0.6, animations: {
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in }
    }

    func animateViewsOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.8) {
            self.loginLabel.transform = CGAffineTransform(translationX: 0, y: -800)
            self.loginLabel.alpha = 1
        }

        UIView.animate(withDuration: 0.8, delay: 0.2, animations: {
            self.usernameLabel.transform = CGAffineTransform(translationX: 250, y: -800)
            self.usernameInput.transform = CGAffineTransform(translationX: 250, y: -800)
        }) { _ in }

        UIView.animate(withDuration: 0.8, delay: 0.4, animations: {
            self.passwordLabel.transform = CGAffineTransform(translationX: 250, y: -800)
            self.passwordInput.transform = CGAffineTransform(translationX: 250, y: -800)
        }) { _ in }

        UIView.animate(withDuration: 0.8, delay: 0.6, animations: {
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: -1300)
        }) { _ in completion() }
    }
}

extension LoginViewController {
    func setupViews() {

        self.view.backgroundColor = .white

        loginLabel = UILabel()
        loginLabel.text = "QUIZZER LOGIN"
        loginLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        loginLabel.alpha = 0.3
        self.view.addSubview(loginLabel)

        usernameLabel = UILabel()
        usernameLabel.text = "Username:"
        self.view.addSubview(usernameLabel)

        usernameInput = UITextField()
        usernameInput.placeholder = "example@example.xyz"
        self.view.addSubview(usernameInput)

        passwordLabel = UILabel()
        passwordLabel.text = "Password:"
        self.view.addSubview(passwordLabel)

        passwordInput = UITextField()
        passwordInput.placeholder = "password1!"
        passwordInput.isSecureTextEntry = true
        self.view.addSubview(passwordInput)

        loginButton = UIButton()
        loginButton.setTitle("Log in", for: .normal)
        loginButton.setTitleColor(.blue, for: .normal)
        self.view.addSubview(loginButton)

        loginErrorLabel = UILabel()
        loginErrorLabel.text = "There was an error logging in, please check username & password and try again"
        loginErrorLabel.textColor = .red
        self.view.addSubview(loginErrorLabel)

        appTitleLabelConstraint = loginLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 145)
        loginLabel.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 16)

        usernameLabel.autoPinEdge(.top, to: .bottom, of: loginLabel, withOffset: 32)
        usernameLabel.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: -210)

        usernameInput.autoPinEdge(.top, to: .bottom, of: usernameLabel, withOffset: 8)
        usernameInput.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: -210)
        usernameInput.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -40)

        passwordLabel.autoPinEdge(.top, to: .bottom, of: usernameInput, withOffset: 20)
        passwordLabel.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: -210)

        passwordInput.autoPinEdge(.top, to: .bottom, of: passwordLabel, withOffset: 8)
        passwordInput.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: -210)
        passwordInput.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -40)

        loginButtonConstraint = loginButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        loginButton.autoAlignAxis(toSuperviewAxis: .vertical)
        loginButton.addTarget(self, action: #selector(self.onLoginPressed), for: .touchUpInside)

        loginErrorLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        loginErrorLabel.autoPinEdge(.bottom, to: .top, of: loginButton, withOffset: -16)
        loginErrorLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        loginErrorLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        loginErrorLabel.textAlignment = .center
        loginErrorLabel.numberOfLines = 5
        loginErrorLabel.isHidden = true
    }
}
