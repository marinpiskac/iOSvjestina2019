//
//  QuizService.swift
//  ruazosi
//
//  Created by Marin Piskac on 01/04/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import Foundation

class QuizService {
    let persistenceService: PersistenceService

    init(persistenceService: PersistenceService) {
        self.persistenceService = persistenceService
    }

    func fetchQuizzes(_ completion: @escaping (([Quiz]) -> Void)) {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return }

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(persistenceService.getAuthData()?.token ?? "", forHTTPHeaderField: "Authorization")

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])

                    if let jsonDict = json as? Dictionary<String, Any>,
                       let quizzArray = jsonDict["quizzes"] as? [Any] {
                        let mappedArray = quizzArray.compactMap { quizJson in Quiz(json: quizJson) }

                        completion(mappedArray)
                    }
                } catch {}
            }
        }

        dataTask.resume()
    }

    func sendResult(quizId: Int, noOfCorrect: Int, time: Double, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result") else { return }

        let userData = persistenceService.getAuthData()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(persistenceService.getAuthData()?.token ?? "", forHTTPHeaderField: "Authorization")
        let data = ["quiz_id": quizId, "user_id": userData?.userId ?? -1, "time": time, "no_of_correct": noOfCorrect] as [String: Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            urlRequest.httpBody = jsonData

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let responseCast = response as? HTTPURLResponse,
                   responseCast.statusCode == 200 {
                    //all is well
                    completion(true)
                } else {
                    //not all is well
                    completion(false)
                }
            }

            dataTask.resume()
        } catch {}

    }
}
