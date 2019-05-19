//
//  QuizTableViewCell.swift
//  ruazosi
//
//  Created by Marin Piskac on 07/04/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {

   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
