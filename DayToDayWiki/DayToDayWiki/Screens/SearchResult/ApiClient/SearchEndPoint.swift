//
//  SearchEndPoint.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 25/11/20.
//

import Foundation

enum SearchEndPoint {
    case fetchSearchResults(searchText: String)
}

extension SearchEndPoint: EndPointType {
    var task: HTTPTask {
        switch self {
        case .fetchSearchResults(let searchText):
            var urlParameters = Parameters()
            urlParameters[NetworkConstants.action] = "query"
            urlParameters[NetworkConstants.format] = "json"
            urlParameters[NetworkConstants.prop] = "info|pageimages|pageterms"
            urlParameters[NetworkConstants.generator] = "prefixsearch"
            urlParameters[NetworkConstants.inProp] = "url"
            urlParameters[NetworkConstants.redirects] = 1
            urlParameters[NetworkConstants.formatVersion] = 2
            urlParameters[NetworkConstants.gpsLimit] = 10
            urlParameters[NetworkConstants.gpsSearch] = searchText
            
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: urlParameters)
        }
    }
}
