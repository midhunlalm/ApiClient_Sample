//
//  PageItem.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import Foundation

struct PageItem: Decodable {
    let pageId: Int
    let title: String?
    let fullUrl: String?
    let thumbnail: Thumbnail?
    
    enum CodingKeys: String, CodingKey {
        case pageId = "pageid"
        case title
        case fullUrl = "fullurl"
        case thumbnail
    }
}

struct Thumbnail: Decodable {
    let width: Int?
    let height: Int?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case imageUrl = "source"
    }
}
