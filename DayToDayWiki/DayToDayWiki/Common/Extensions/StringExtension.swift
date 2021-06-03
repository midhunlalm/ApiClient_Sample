//
//  StringExtension.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import Foundation

extension String {
    static func getStringOfClass(objectClass: AnyClass) -> String {
        let className = String(describing: objectClass.self)
        return className
    }
}
