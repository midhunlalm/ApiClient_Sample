//
//  NetworkService.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 25/11/20.
//

import Foundation

protocol NetworkServiceProtocol: class {
    
    func execute<T>(completion: @escaping (Result<T, Error>) -> Void) where T: Decodable
}

class NetworkService<EndPoint: EndPointType>: NetworkServiceProtocol {
    private(set) var request: URLRequest?
    private(set) var route: EndPoint?
    private var task: URLSessionTask?
    private var response: URLResponse?
    private var session: URLSession {
        return URLSession.shared
    }
    
    func makeRequest(for route: EndPoint) -> NetworkService {
        self.route = route
        self.request = buildRequest(from: route)
        return self
    }
    
    func execute<T>(completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        task = session.dataTask(with: request!,
                                completionHandler: { [weak self] data, response, error in
                                    guard let `self` = self else { return }
                                    self.response = response
                                    let resultStatus = self.handleNetworkResponse(response, data: data, error: error)
                                    DispatchQueue.main.async { [weak self] in
                                        guard let `self` = self else { return }
                                        switch resultStatus {
                                        case .success:
                                            self.handleSuccessResponse(data: data, responseType: T.self, completion: completion)
                                        case .failure(let error):
                                            completion(.failure(error))
                                        }
                                    }
                                })
        task?.resume()
    }
}

private extension NetworkService {
    var somethingWentWrongError: Error {
        let userInfo = [NSLocalizedDescriptionKey: "Something Went Wrong"]
        return NSError(domain: "", code: 400, userInfo: userInfo) as Error
    }
    
    func buildRequest(from route: EndPoint) -> URLRequest? {
        guard let url = URL(string: route.baseURL) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(route.path),
                                    cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
        urlRequest.httpMethod = route.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = route.headers
        
        switch route.task {
        case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters):
            configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding,
                                urlParameters: urlParameters, request: &urlRequest)
            
        case .requestParametersAndHeaders(let bodyParameters, let bodyEncoding,
                                          let urlParameters, let additionalHeaders):
            addAdditionalHeaders(additionalHeaders, request: &urlRequest)
            configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding,
                                urlParameters: urlParameters, request: &urlRequest)
        default:
            break
        }
        return urlRequest
    }
    
    func handleNetworkResponse(_ urlResponse: URLResponse?, data: Data?, error: Error?) -> Result<Bool, Error> {
        //Server throw error, return early
        if let error = error {
            return .failure(error)
        }
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {return .failure(somethingWentWrongError)}
        
        switch httpURLResponse.statusCode {
        case 200...399:
            return .success(true)
        default:
            return .failure(somethingWentWrongError)
        }
    }
    
    func configureParameters(bodyParameters: Parameters?,
                             bodyEncoding: ParameterEncoding,
                             urlParameters: Parameters?,
                             request: inout URLRequest) {
        try? bodyEncoding.encode(urlRequest: &request,
                                 bodyParameters: bodyParameters, urlParameters: urlParameters)
    }
    
    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func handleSuccessResponse<T: Decodable>(data: Data?, responseType: T.Type,
                                             completion: @escaping (Result<T, Error>) -> Void) {
        guard let data = data else {
            completion(.failure(somethingWentWrongError))
            return
        }
        if let responseObject = parseResponse(data, responseType: responseType) {
            completion(.success(responseObject))
        } else {
            completion(.failure(somethingWentWrongError))
        }
    }
    
    func parseResponse<T: Decodable>(_ response: Data?, responseType: T.Type) -> T? {
        guard let data = response, !data.isEmpty else {
            return nil
        }
        return try? JSONDecoder().decode(responseType.self, from: data)
    }
}
