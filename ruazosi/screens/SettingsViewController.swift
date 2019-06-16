//
// Created by Marin Piskac on 2019-06-16.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import UIKit
import PureLayout

class SettingsViewController: UIViewController {
    var usernameLabel: UILabel!
    var logoutButton: UIButton!

    var persistenceService: PersistenceService?
    var router: Router?

    convenience init(persistenceService: PersistenceService, router: Router){
        self.init()
        self.persistenceService = persistenceService
        self.router = router
        self.navigationItem.title = "Settings"
        setupViews()
    }

    @objc func onLogoutTapped(){
        persistenceService?.deleteAuthData()
        router?.resetToLoginScreen()
    }
}

extension SettingsViewController{
    func setupViews() {
        self.view.backgroundColor = .white

        usernameLabel = UILabel()
        usernameLabel.text = persistenceService?.getAuthData()?.username
        usernameLabel.textColor = .black
        self.view.addSubview(usernameLabel)

        usernameLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 16)
        usernameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 32)

        logoutButton = UIButton()
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.blue, for: .normal)
        logoutButton.addTarget(self, action: #selector(onLogoutTapped), for: .touchUpInside)
        self.view.addSubview(logoutButton)

        logoutButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 32)
        logoutButton.autoAlignAxis(.horizontal, toSameAxisOf: usernameLabel)
    }
}
