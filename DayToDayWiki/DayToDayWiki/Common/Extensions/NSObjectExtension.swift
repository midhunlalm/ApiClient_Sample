//
//  NSObjectExtension.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import Foundation

extension NSObject {
    /**
     @abstract Variable to get class name
     */
    var className: String {
        return String(describing: type(of: self))
    }
    /**
     @abstract Class variable to get class name
     */
    class var className: String {
        return String(describing: self)
    }
}
