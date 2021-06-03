//
//  BaseViewModel.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import Foundation

class BaseViewModel {
    var reloadHandler: (()-> Void)?
    var errorHandler: ((Error?)-> Void)?
    var loaderHandler: ((Bool?)-> Void)?
    var shouldShowLoader = false {
        didSet {
            self.loaderHandler?(shouldShowLoader)
        }
    }
}
