//
//  ImageService.swift
//  ruazosi
//
//  Created by Marin Piskac on 11/04/2019.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    func getImage(from url: URL?, complete: @escaping (UIImage)->Void) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil, let image = UIImage(data: data) else { return }
            
           complete(image)
        }.resume()
    }

    func getImage(from url: String?,  complete: @escaping (UIImage)->Void) {
        guard let url = url else { return }

        self.getImage(from: URL(string: url), complete: complete)
    }
}
