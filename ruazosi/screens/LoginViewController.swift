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

    convenience init(authService: AuthService, router: Router){
        self.init()
        self.authService = authService
        self.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func onLoginPressed() {
        authService?.logIn(usernameInput.text , passwordInput.text, {success in
            DispatchQueue.main.async{
                if(success){
                    self.router?.resetToQuizzesScreen()
                }else{
                    self.loginErrorLabel.isHidden = false
                }
            }
        })
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            loginButtonConstraint.constant = -keyboardHeight - 14
        }else{
            loginButtonConstraint.constant = -360
        }
        appTitleLabelConstraint.constant = 0
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        appTitleLabelConstraint.constant = 195
        loginButtonConstraint.constant = 145
    }
}

extension LoginViewController {
    func setupViews() {

        self.view.backgroundColor = .white

        loginLabel = UILabel()
        loginLabel.text = "QUIZZER LOGIN"
        loginLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
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
        loginLabel.autoPinEdge(.leading, to: .leading, of: usernameInput)

        usernameLabel.autoPinEdge(.top, to: .bottom, of: loginLabel, withOffset: 32)
        usernameLabel.autoPinEdge(.leading, to: .leading, of: usernameInput)

        usernameInput.autoPinEdge(.top, to: .bottom, of: usernameLabel, withOffset: 8)
        usernameInput.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 40)
        usernameInput.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -40)

        passwordLabel.autoPinEdge(.top, to: .bottom, of: usernameInput, withOffset: 20)
        passwordLabel.autoPinEdge(.leading, to: .leading, of: usernameInput)

        passwordInput.autoPinEdge(.top, to: .bottom, of: passwordLabel, withOffset: 8)
        passwordInput.autoPinEdge(.leading, to: .leading, of: usernameInput)
        passwordInput.autoPinEdge(.trailing, to: .trailing, of: usernameInput)

        loginButtonConstraint = loginButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        loginButton.autoAlignAxis(toSuperviewAxis: .vertical)
        loginButton.addTarget(self, action: #selector(self.onLoginPressed), for: .touchUpInside)

        loginErrorLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        loginErrorLabel.autoPinEdge(.bottom, to: .top, of: loginButton, withOffset: -16)
        loginErrorLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        loginErrorLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        loginErrorLabel.textAlignment =  .center
        loginErrorLabel.numberOfLines = 5
        loginErrorLabel.isHidden = true
    }
}
