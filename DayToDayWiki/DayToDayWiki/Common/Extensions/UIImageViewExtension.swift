//
//  UIImageViewExtension.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 25/11/20.
//

import UIKit

extension UIImageView {
    func setImageFromUrl(_ urlString: String?) {
        if let urlString = urlString {
            if let image = AppDataManager.shared.getImageFromCache(urlString) {
                self.image = image
            } else {
                downloadImageFromUrl(urlString)
            }
        }
    }
}

private extension UIImageView {
    func downloadImageFromUrl(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                if error == nil, let data = data, let image = UIImage(data: data) {
                    self.image = image
                    AppDataManager.shared.addImageToCache(image, urlString: urlString)
                }
            }
        }
        task.resume()
    }
}
