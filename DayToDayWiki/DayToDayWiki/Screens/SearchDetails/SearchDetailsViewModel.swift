//
//  SearchDetailsViewModel.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import Foundation

class SearchDetailsViewModel: BaseViewModel {
    private let resultItem: PageItem
    
    var title: String {
        return resultItem.title ?? ""
    }
    
    var webUrl: URL? {
        guard let urlString = resultItem.fullUrl else {
            return nil
        }
        return URL(string: urlString)
    }
    
    // MARK: Intializer
    init(resultItem: PageItem) {
        self.resultItem = resultItem
    }
}
