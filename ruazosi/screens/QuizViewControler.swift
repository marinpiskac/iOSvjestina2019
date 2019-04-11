//
//  QuizViewControler.swift
//  ruazosi
//
//  Created by Marin Piskac on 01/04/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import UIKit

class QuizViewControler: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let quizService = QuizService()
    
    let imageService = ImageService()

    @IBOutlet weak var funFactLabel: UILabel!

    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var quizTableView: UITableView!

    @IBOutlet weak var questionView: QuestionView!

    
    var quizzes: [Quiz] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        quizTableView.dataSource = self
        quizTableView.delegate = self

        quizTableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizCell")
    }

    @IBAction func onFetchButtonClick(_ sender: UIButton) {
        quizService.fetchQuizzes() { quizzes in
            if let unwrappedQuizzes = quizzes {

                let brojPitanjaNBA = unwrappedQuizzes
                        .flatMap { quiz in quiz.questions }
                        .filter { question in question.question.contains("NBA") }
                        .count

                let funFactText = ((brojPitanjaNBA >= 2 && brojPitanjaNBA <= 4) ? "Postoje " : "Postoji ")
                        + brojPitanjaNBA.description
                        + (brojPitanjaNBA == 1 ? " pitanje u kojem" : " pitanja u kojima")
                        + " se spominje NBA"

                DispatchQueue.main.async {
                    self.quizzes = unwrappedQuizzes
                    self.funFactLabel.text = funFactText
                    self.quizTableView.reloadData()
                    self.errorLabel.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.quizzes = []
                    self.quizTableView.reloadData()
                    self.errorLabel.isHidden = false
                }
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizzes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizTableView.dequeueReusableCell(withIdentifier: "quizCell") as! QuizTableViewCell
        let quiz = self.quizzes[indexPath.row]

        cell.titleLabel?.text = quiz.title
        cell.descriptionLabel?.text = quiz.description
        imageService.getImage(from: quiz.image){downloadedImage in
            DispatchQueue.main.async {
                cell.quizImage?.image = downloadedImage
            }
        }
        cell.backgroundColor = quiz.category.color

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let selectedQuiz = quizzes[indexPath.row]
        let randomQuestion = selectedQuiz.questions[Int.random(in: 0...selectedQuiz.questions.count-1)]

        quizTableView.isHidden = true
        questionView.setup(question: randomQuestion)
        questionView.isHidden = false
    }
}
