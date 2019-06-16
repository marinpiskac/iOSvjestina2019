//
// Created by Marin Piskac on 2019-04-07.
// Copyright (c) 2019 Marin Piskač. All rights reserved.
//

import Foundation
import UIKit

enum QuizType: String {
    case SPORTS = "SPORTS"
    case SCIENCE = "SCIENCE"
    case UNKNOWN = "UNKNOWN"

    init(text: String) {
        switch (text) {
        case "SPORTS": self = .SPORTS
        case "SCIENCE": self = .SCIENCE
        default: self = .UNKNOWN
        }
    }

    var color: UIColor {
        switch (self) {
        case .SPORTS: return UIColor(red: 0.41, green: 1.00, blue: 0.57, alpha: 0.5)
        case .SCIENCE: return UIColor(red: 0.41, green: 0.64, blue: 1.00, alpha: 0.5)
        case .UNKNOWN: return UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.5)
        }
    }

    var name: String {
        switch (self) {
        case .SPORTS:
            return "Sports"
        case .SCIENCE:
            return "Science"
        case .UNKNOWN:
            return "Unknown"
        }
    }
}
