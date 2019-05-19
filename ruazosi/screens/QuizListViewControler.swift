//
//  QuizListViewControler.swift
//  ruazosi
//
//  Created by Marin Piskac on 01/04/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import UIKit
import Kingfisher

class QuizListViewControler: UIViewController {

    var quizService: QuizService?

    var router: Router?

    var quizzes: [QuizType: [Quiz]] = [:]

    @IBOutlet weak var funFactLabel: UILabel!

    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var quizTableView: UITableView!

    convenience init(quizService: QuizService, router: Router) {
        self.init()
        self.quizService = quizService
        self.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        quizTableView.dataSource = self
        quizTableView.delegate = self

        quizTableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizTableCell")
    }

    @IBAction func onFetchButtonClick(_ sender: UIButton) {
        quizService?.fetchQuizzes() { quizzes in
            let brojPitanjaNBA = quizzes
                    .flatMap { quiz in quiz.questions }
                    .filter { question in question.question.contains("NBA") }
                    .count

            let funFactText = ((brojPitanjaNBA >= 2 && brojPitanjaNBA <= 4) ? "Postoje " : "Postoji ")
                    + brojPitanjaNBA.description
                    + (brojPitanjaNBA == 1 ? " pitanje u kojem" : " pitanja u kojima")
                    + " se spominje NBA"

            let quizzMap = quizzes.reduce(into: [:]) { (result: inout [QuizType: [Quiz]], quiz: Quiz) in
                if (result.keys.contains(quiz.category)) {
                    result[quiz.category]?.append(quiz)
                } else {
                    result.updateValue([quiz], forKey: quiz.category)
                }
            }

            DispatchQueue.main.async {
                self.quizzes = quizzMap
                self.funFactLabel.text = funFactText
                self.quizTableView.reloadData()
                self.errorLabel.isHidden = true
            }
        }
    }
}

extension QuizListViewControler: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return quizzes.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes[Array(quizzes.keys)[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizTableView.dequeueReusableCell(withIdentifier: "quizTableCell", for: indexPath) as! QuizTableViewCell
        let quiz = quizzes[Array(quizzes.keys)[indexPath.section]]![indexPath.row]

        cell.titleLabel?.text = quiz.title
        cell.descriptionLabel?.text = quiz.description
        if let image = quiz.image {
            cell.quizImage?.kf.setImage(with: URL(string: image))
        }
        cell.backgroundColor = quiz.category.color

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuiz = self.quizzes[Array(quizzes.keys)[indexPath.section]]![indexPath.row]

        router?.pushQuizView(quiz: selectedQuiz)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        let sectionType = Array(quizzes.keys)[section] as QuizType
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
