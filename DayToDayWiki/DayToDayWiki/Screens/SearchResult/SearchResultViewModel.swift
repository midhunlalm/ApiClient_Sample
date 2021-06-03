//
//  SearchResultViewModel.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import Foundation

class SearchResultViewModel: BaseViewModel {
    private let apiClient: SearchApiClientProtocol
    private var searchResult: SearchResult?
    
    var searchText: String? {
        didSet {
            fetchSearchResults()
        }
    }
    
    var resultItems: [PageItem]? {
        return searchResult?.resultQuery?.pages
    }
    
    // MARK: Intializer
    init(apiClient: SearchApiClientProtocol = SearchApiClient()) {
        self.apiClient = apiClient
    }
}

// MARK: - Public Methods
extension SearchResultViewModel {
    func getSearchItem(for index: Int) -> PageItem? {
        guard let resultItems = resultItems, resultItems.indices.contains(index) else {
            return nil
        }
        return resultItems[index]
    }
}

// MARK: - Private Methods
private extension SearchResultViewModel {
    func fetchSearchResults() {
        guard let searchText = searchText else { return }
        shouldShowLoader = true
        apiClient.fetchSearchResults(searchText: searchText) { [weak self] (result) in
            guard let `self` = self else { return }
            self.shouldShowLoader = false
            switch result {
            case .success(let response):
                self.searchResult = response
                self.reloadHandler?()
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }
}
