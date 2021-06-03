//
//  SearchDetailsController.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import UIKit
import WebKit

class SearchDetailsController: BaseController {
    private var webView: WKWebView!
    
    var viewModel: SearchDetailsViewModel!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
}

// MARK: - Private Methods
private extension SearchDetailsController {
    func setupInterface() {
        screenTitle = viewModel.title
        if let webUrl = viewModel.webUrl {
            loadWebViewContent(url: webUrl)
        }
    }
    
    func loadWebViewContent(url: URL) {
        showLoader(inView: webView)
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

// MARK: - WKNavigationDelegate
extension SearchDetailsController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoader()
    }
}
