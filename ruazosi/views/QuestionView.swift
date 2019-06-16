//
//  QuestionView.swift
//  ruazosi
//
//  Created by Marin Piskac on 11/04/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var questionView: UILabel!

    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!

    var currentQuestion: Question?

    var completion: ((Bool)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)
        contentView.fixInView(self)
    }

    func setup(question: Question, completion: @escaping (Bool)->Void) {
        self.currentQuestion = question
        self.completion = completion

        questionView?.text = question.question

        if (question.answers.count != 4) {
            print("Error: invalid number of answers ")
            return
        }

        answer1.setTitle(question.answers[0], for: .normal)
        answer1.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        answer2.setTitle(question.answers[1], for: .normal)
        answer2.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        answer3.setTitle(question.answers[2], for: .normal)
        answer3.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        answer4.setTitle(question.answers[3], for: .normal)
        answer4.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }

    @objc func buttonClicked(_ sender: UIButton?) {
        guard let selectedAnswer = sender?.titleLabel?.text else { return }

        if (Int(self.currentQuestion?.correctAnswer ?? -1) == self.currentQuestion?.answers.firstIndex(of: selectedAnswer)) {
            sender?.setTitleColor(UIColor.black, for: .normal)
            sender?.backgroundColor = UIColor.green
            completion?(true)
        } else {
            sender?.setTitleColor(UIColor.white, for: .normal)
            sender?.backgroundColor = UIColor.red
            completion?(false)
        }
    }
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
