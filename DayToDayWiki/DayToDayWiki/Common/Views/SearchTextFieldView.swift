//
//  SearchTextFieldView.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import UIKit

class SearchTextFieldView: UIView {
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1.0
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.delegate = self
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "search"), for: .normal)
        button.addTarget(self, action: #selector(didClickedSearchButton), for: .touchUpInside)
        return button
    }()
    
    var textBeginAction: ((String?) -> Void)?
    var textEndAction: ((String?) -> Void)?
    var textDidChange: ((String?) -> Bool)?
    var textFieldShouldReturn: (() -> Bool)?
    
    var text: String? {
        didSet { searchTextField.text = text }
    }
    var placeholder: String? {
        didSet { searchTextField.placeholder = placeholder }
    }
    var textColor: UIColor? {
        didSet { searchTextField.textColor = textColor }
    }
    
    required init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    @objc func didClickedSearchButton() {
        searchTextField.resignFirstResponder()
    }
}

private extension SearchTextFieldView {
    func setupViews() {
        addSubview(contentView)
        contentView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 5, bottomConstant: 5, leftConstant: 5, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        contentView.addSubview(searchButton)
        searchButton.anchorCenterYToSuperview()
        searchButton.anchor(top: nil, bottom: nil, left: nil, right: contentView.rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 5, widthConstant: 25, heightConstant: 25)
        
        contentView.addSubview(searchTextField)
        searchTextField.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, left: contentView.leftAnchor, right: searchButton.leftAnchor, topConstant: 5, bottomConstant: 5, leftConstant: 5, rightConstant: 5, widthConstant: 0, heightConstant: 0)
    }
}

extension SearchTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textBeginAction = textBeginAction else { return }
        textBeginAction(textField.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textEndAction = textEndAction else { return }
        textEndAction(textField.text)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let textDidChange = textDidChange else { return true }
        guard let text = textField.text else { return false }
        guard let stringRange = Range(range, in: text) else { return false }

        let newString = text.replacingCharacters(in: stringRange, with: string)
        return textDidChange(newString)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textFieldShouldReturn = textFieldShouldReturn else { return true }
        return textFieldShouldReturn()
    }
}
