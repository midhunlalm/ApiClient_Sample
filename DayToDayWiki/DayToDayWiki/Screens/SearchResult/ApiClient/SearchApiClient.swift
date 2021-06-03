//
//  SearchApiClient.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 25/11/20.
//

import Foundation

protocol SearchApiClientProtocol {
    func fetchSearchResults(searchText: String,
                            completion: @escaping (Result<SearchResult, Error>) -> Void)
}

class SearchApiClient: SearchApiClientProtocol {
    private let networkService = NetworkService<SearchEndPoint>()
    
    func fetchSearchResults(searchText: String,
                            completion: @escaping (Result<SearchResult, Error>) -> Void) {
        self.networkService.makeRequest(for: .fetchSearchResults(searchText: searchText)).execute(completion: completion)
    }
}
