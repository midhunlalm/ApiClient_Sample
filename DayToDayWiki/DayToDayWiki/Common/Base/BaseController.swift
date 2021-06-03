//
//  BaseController.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import UIKit

class BaseController: UIViewController {
    private var activityView: UIActivityIndicatorView?
    
    var screenTitle: String? {
        didSet {
            self.navigationItem.title = screenTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Loader Handling
extension BaseController {
    func showLoader(inView view: UIView?) {
        guard let view = view else { return }
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.anchorCenterXToSuperview()
        activityIndicator.anchorCenterYToSuperview()
        activityView = activityIndicator
    }
    
    func hideLoader() {
        activityView?.removeFromSuperview()
    }
}

// MARK: - Keyboard Handling
extension BaseController {
    func dismissKeypadOnTapOutside() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Alerts
extension BaseController {
    /**
     @abstract Method to show alert with title and message with ok button.
     */
    func showAlert(title: String?, message: String?) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: Constants.ok, style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    /**
     @abstract Method to show alert for error.
     */
    func showAlert(error: Error?) {
        guard let error = error else { return }
        showAlert(title: Constants.error, message: error.localizedDescription)
    }
}
