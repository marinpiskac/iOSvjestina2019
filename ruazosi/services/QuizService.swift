//
//  QuizService.swift
//  ruazosi
//
//  Created by Marin Piskac on 01/04/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import Foundation

class QuizService {
    func fetchQuizzes(_ completion: @escaping (([Quiz]?) -> Void)) {
        if let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") {
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? Dictionary<String, Any>,
                           let quizzArray = jsonDict["quizzes"] as? [Any] {
                            let mappedArray = quizzArray.compactMap { quizJson in Quiz(json: quizJson) }

                            completion(mappedArray)
                        }
                    } catch {
                        completion(nil)
                    }
                }else{
                    completion(nil)
                }
            }

            dataTask.resume()
        }
    }
}
