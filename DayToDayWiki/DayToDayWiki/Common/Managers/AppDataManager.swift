//
//  AppDataManager.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import Foundation
import UIKit

final class AppDataManager {
    private static let sharedInstance = AppDataManager()
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    private init() { }
    
    class var shared: AppDataManager {
        return sharedInstance
    }
    
    func addImageToCache(_ image: UIImage?, urlString: String) {
        if let image = image {
            imageCache.setObject(image, forKey: urlString as AnyObject)
        }
    }
    
    func getImageFromCache(_ urlString: String) -> UIImage? {
        if let image = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            return image
        }
        return nil
    }
}
