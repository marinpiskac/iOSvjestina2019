//
// Created by Marin Piskac on 2019-06-16.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import UIKit
import PureLayout

class PlainCollectionViewCell: UICollectionViewCell {
    var label: UILabel?
    var standing: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        standing = UILabel()
        self.addSubview(standing!)

        standing?.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        standing?.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        standing?.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        standing?.autoPinEdge(.trailing, to: .leading, of: self, withOffset: 66)

        label = UILabel()
        self.addSubview(label!)

        label?.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        label?.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        label?.autoPinEdge(.leading, to: .trailing, of: standing!)
        label?.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        label?.textAlignment = .left
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
