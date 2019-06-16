//
// Created by Marin Piskac on 2019-06-16.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import UIKit
import PureLayout

class SearchViewController: UIViewController {
    var router: Router?
    var quizzes: [Quiz] = []
    var mappedQuizzes: [QuizType: [Quiz]] = [:]

    var searchInput: UITextField!
    var quizzesTableView: UITableView!

    convenience init(router: Router) {
        self.init()
        self.router = router
        self.navigationItem.title = "Search"

        setupViews()
        quizzes = DataController.shared.fetchQuizzes()
        divideQuizzesIntoMap(quizzes: quizzes)
    }

    func divideQuizzesIntoMap(quizzes: [Quiz]) {
        mappedQuizzes = quizzes.reduce(into: [:]) { (result: inout [QuizType: [Quiz]], quiz: Quiz) in
            if (result.keys.contains(quiz.enumCategory)) {
                result[quiz.enumCategory]?.append(quiz)
            } else {
                result.updateValue([quiz], forKey: quiz.enumCategory)
            }
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if (textField.text?.isEmpty ?? true) {
            divideQuizzesIntoMap(quizzes: quizzes)
        } else {
            divideQuizzesIntoMap(quizzes: quizzes.filter { (quiz: Quiz) -> Bool in
                quiz.title?.lowercased().contains(textField.text!.lowercased()) ?? true
            })
        }

        quizzesTableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return mappedQuizzes.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mappedQuizzes[Array(mappedQuizzes.keys)[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizzesTableView.dequeueReusableCell(withIdentifier: "quizTableCell", for: indexPath) as! QuizTableViewCell
        let quiz = mappedQuizzes[Array(mappedQuizzes.keys)[indexPath.section]]![indexPath.row]

        cell.titleLabel?.text = quiz.title
        cell.descriptionLabel?.text = quiz.quizDescription
        if let image = quiz.image {
            cell.quizImage?.kf.setImage(with: URL(string: image))
        }
        cell.backgroundColor = quiz.enumCategory.color

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuiz = self.mappedQuizzes[Array(mappedQuizzes.keys)[indexPath.section]]![indexPath.row]

        router?.pushQuizView(quiz: selectedQuiz)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        let sectionType = Array(mappedQuizzes.keys)[section] as QuizType
        view.text = sectionType.name
        view.backgroundColor = sectionType.color
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 24.0)

        return view
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}

extension SearchViewController {
    func setupViews() {
        self.view.backgroundColor = .white

        searchInput = UITextField()
        searchInput.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchInput.placeholder = "Search"
        self.view.addSubview(searchInput)

        searchInput.autoPinEdge(toSuperviewSafeArea: .top, withInset: 16)
        searchInput.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        searchInput.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)

        quizzesTableView = UITableView()
        quizzesTableView.delegate = self
        quizzesTableView.dataSource = self
        quizzesTableView.separatorStyle = .none
        quizzesTableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizTableCell")
        self.view.addSubview(quizzesTableView)

        quizzesTableView.autoPinEdge(.top, to: .bottom, of: searchInput, withOffset: 16)
        quizzesTableView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        quizzesTableView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        quizzesTableView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 16)
    }
}
