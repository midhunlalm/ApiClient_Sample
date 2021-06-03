//
//  SearchResult.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import Foundation

struct SearchResult: Decodable {
    let batchComplete: Bool
    let resultQuery: ResultQuery?
    
    enum CodingKeys: String, CodingKey {
        case batchComplete = "batchcomplete"
        case resultQuery = "query"
    }
}

struct ResultQuery: Decodable {
    let pages: [PageItem]?
}
