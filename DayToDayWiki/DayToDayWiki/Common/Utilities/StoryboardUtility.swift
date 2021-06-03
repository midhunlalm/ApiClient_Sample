//
//  StoryboardUtility.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func instantiateVC<T: UIViewController>() -> T {
        return self.instance.instantiateViewController(withIdentifier: T.className) as! T
    }
}
