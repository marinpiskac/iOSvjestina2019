//
// Created by Marin Piskac on 2019-06-16.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import UIKit
import PureLayout

class LeaderboardViewController: UIViewController {
    var resultsCollectionView: UICollectionView!
    var quizId: Int?
    var quizService: QuizService?
    var scores: [QuizLeaderboardScore] = []

    convenience init(quizService: QuizService, quizId: Int) {
        self.init()
        self.quizService = quizService
        self.quizId = quizId
    }

    override func viewDidLoad() {
        setupViews()
    }
}

extension LeaderboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.scores.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let plainCell = resultsCollectionView?.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlainCollectionViewCell
        plainCell.standing?.text = "#" + indexPath.row.description
        plainCell.label?.text = scores[indexPath.row].userId + ": " + scores[indexPath.row].score.description
        return plainCell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(50))
    }
}

extension LeaderboardViewController {
    func setupViews() {
        guard let quizId = quizId else { return }

        self.view.backgroundColor = .white

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)

        resultsCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        resultsCollectionView.register(PlainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        resultsCollectionView.dataSource = self
        resultsCollectionView.delegate = self
        resultsCollectionView.backgroundColor = .white
        self.view.addSubview(resultsCollectionView)

        resultsCollectionView.autoPinEdge(toSuperviewEdge: .top)
        resultsCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
        resultsCollectionView.autoPinEdge(toSuperviewEdge: .leading)
        resultsCollectionView.autoPinEdge(toSuperviewEdge: .trailing)

        self.view.layoutSubviews()

        self.quizService?.getLeaderboard(quizId: quizId) { (quizScoresArray: [QuizLeaderboardScore]) in
            DispatchQueue.main.async {
                self.scores = quizScoresArray
                self.resultsCollectionView.reloadData()
            }
        }
    }
}
