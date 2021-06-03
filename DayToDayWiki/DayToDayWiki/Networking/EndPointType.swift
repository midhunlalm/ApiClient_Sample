//
//  EndPointType.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 25/11/20.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var task: HTTPTask { get }
    var mockFile: String? { get }
}

extension EndPointType {
    var baseURL: String {
        return "https://en.wikipedia.org/"
    }
    
    var path: String {
        return "w/api.php"
    }

    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    var task: HTTPTask {
        return .request
    }

    var mockFile: String? {
        return nil
    }
}
