//
//  SearchResultController.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import UIKit

class SearchResultController: BaseController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextFieldView: SearchTextFieldView!
    
    var viewModel: SearchResultViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupProperties()
        setupBindings()
    }
}

private extension SearchResultController {
    func setupInterface() {
        screenTitle = ScreenTitle.search
    }
    
    func setupProperties() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.registerNib(SearchResultCell.self)
        
        searchTextFieldView.textEndAction = { [weak self] (text) -> Void in
            self?.dismissKeyboard()
            self?.viewModel.searchText = text
        }
        
        searchTextFieldView.textFieldShouldReturn = { [weak self] () -> Bool in
            self?.dismissKeyboard()
            return true
        }
    }
    
    func setupBindings() {
        viewModel.reloadHandler = { [weak self] in
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
            self?.scrollTableViewToTop()
        }
        viewModel.errorHandler = { [weak self] (error) in
            self?.showAlert(error: error)
        }
        viewModel?.loaderHandler = { [weak self] (shouldShow) in
            if let shouldShow = shouldShow, shouldShow == true {
                self?.showLoader(inView: self?.view)
            } else {
                self?.hideLoader()
            }
        }
    }
    
    func scrollTableViewToTop() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension SearchResultController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.resultItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SearchResultCell.self, indexPath: indexPath)
        cell.configure(item: viewModel.getSearchItem(for: indexPath.row))
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchResultController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.getSearchItem(for: indexPath.row) else { return }
        let searchDetailsVM = SearchDetailsViewModel(resultItem: item)
        let searchDetailsVC: SearchDetailsController = Storyboard.main.instantiateVC()
        searchDetailsVC.viewModel = searchDetailsVM
        navigationController?.pushViewController(searchDetailsVC, animated: true)
    }
}
