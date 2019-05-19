//
//  LoginViewController.swift
//  ruazosi
//
//  Created by Marin Piskac on 15/05/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import UIKit
import PureLayout
import Kingfisher

class QuizViewController: UIViewController {

    var quizName: UILabel!
    var quizImage: UIImageView!
    var startButton: UIButton!
    var questionsScrollView: UIScrollView!

    var quizService: QuizService?
    var router: Router?
    var quiz: Quiz?

    var noOfCorrect = 0
    var currentQuestion = 0
    var startTime: Date = Date()

    convenience init(quiz: Quiz, quizService: QuizService, router: Router) {
        self.init()
        self.quiz = quiz
        self.quizService = quizService
        self.router = router
    }

    override func viewDidLoad() {
        setupViews()
    }

    @objc func onStartQuizClicked() {
        if (questionsScrollView.isHidden) {
            questionsScrollView.isHidden = false
            startTime = Date()
            currentQuestion = 0
        }
    }

    func questionAnswered(_ correct: Bool) {
        guard let quiz = quiz else { return }
        currentQuestion += 1
        if (correct && currentQuestion < quiz.questions.count) { noOfCorrect += 1 }

        if (currentQuestion >= quiz.questions.count) {
            let finishTime = Date()
            let totalQuizTime = finishTime.timeIntervalSince(startTime)

            quizService?.sendResult(quizId: quiz.id, noOfCorrect: noOfCorrect, time: totalQuizTime) { successfullySent in
                DispatchQueue.main.async {
                    self.router?.popCurrentView()
                }
            }
        } else {
            questionsScrollView.scrollRectToVisible(
                    CGRect(
                            x: currentQuestion * Int(questionsScrollView.frame.width),
                            y: 0,
                            width: Int(questionsScrollView.frame.width),
                            height: Int(questionsScrollView.contentSize.height)
                    ),
                    animated: true
            )
        }
    }
}

extension QuizViewController {
    func setupViews() {
        guard let quiz = quiz else { return }

        self.view.backgroundColor = .white

        quizName = UILabel()
        quizName.text = quiz.title
        self.view.addSubview(quizName)

        quizImage = UIImageView()
        if let image = quiz.image {
            quizImage.kf.setImage(with: URL(string: image))
        }
        self.view.addSubview(quizImage)

        questionsScrollView = UIScrollView()
        questionsScrollView.isScrollEnabled = false
        questionsScrollView.isPagingEnabled = true
        questionsScrollView.showsHorizontalScrollIndicator = true
        self.view.addSubview(questionsScrollView)

        startButton = UIButton()
        startButton.setTitleColor(.blue, for: .normal)
        startButton.setTitle("Start quiz", for: .normal)
        startButton.addTarget(self, action: #selector(onStartQuizClicked), for: .touchUpInside)
        self.view.addSubview(startButton)

        quizName.autoAlignAxis(toSuperviewAxis: .vertical)
        quizName.autoPinEdge(.top, to: .top, of: self.view, withOffset: 100)

        quizImage.autoPinEdge(.top, to: .bottom, of: quizName, withOffset: 16)
        quizImage.autoMatch(.height, to: .height, of: self.view, withMultiplier: 0.2)
        quizImage.autoPinEdge(toSuperviewEdge: .leading, withInset: 25)
        quizImage.autoPinEdge(toSuperviewEdge: .trailing, withInset: 25)
        quizImage.contentMode = .scaleAspectFit

        startButton.autoPinEdge(.top, to: .bottom, of: quizImage, withOffset: 8)
        startButton.autoAlignAxis(.vertical, toSameAxisOf: quizImage)

        questionsScrollView.autoPinEdge(.top, to: .bottom, of: startButton, withOffset: 8)
        questionsScrollView.autoPinEdge(toSuperviewEdge: .bottom)
        questionsScrollView.autoPinEdge(toSuperviewEdge: .leading, withInset: 8)
        questionsScrollView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 8)

        self.view.layoutSubviews()

        quiz.questions.enumerated().forEach { (index: Int, question: Question) in
            let questionView = QuestionView()
            let itemWidth = Int(self.view.frame.width - CGFloat(16))
            questionView.frame = CGRect(
                    x: itemWidth * index,
                    y: 0,
                    width: itemWidth,
                    height: Int(questionsScrollView.frame.height))
            questionView.setup(question: question, completion: { correct in
                self.questionAnswered(correct)
            })
            questionsScrollView.addSubview(questionView)
        }
        questionsScrollView.contentSize = CGSize(
                width: (self.view.frame.width - CGFloat(16)) * CGFloat(quiz.questions.count),
                height: questionsScrollView.frame.height
        )

        questionsScrollView.isHidden = true
    }
}
