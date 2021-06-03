//
//  ParameterEncoding.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 25/11/20.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum ParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding

    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: Parameters?,
                       urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)

            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                      let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}

public struct JSONParameterEncoder: ParameterEncoder {
    private var encodingFailedError: Error {
        let userInfo = [NSLocalizedDescriptionKey: "Encoding Failed"]
        return NSError(domain: "", code: 401, userInfo: userInfo) as Error
    }
    
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw encodingFailedError
        }
    }
}

public struct URLParameterEncoder: ParameterEncoder {
    private var missingURLError: Error {
        let userInfo = [NSLocalizedDescriptionKey: "Missing URL"]
        return NSError(domain: "", code: 401, userInfo: userInfo) as Error
    }
    
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {

        guard let url = urlRequest.url else { throw missingURLError }

        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true), !parameters.isEmpty {

            urlComponents.queryItems = [URLQueryItem]()
            urlComponents.queryItems = parameters.map({ URLQueryItem(name: $0, value: "\($1)") })
            urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?
                .replacingOccurrences(of: "+", with: "%2B")
            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
