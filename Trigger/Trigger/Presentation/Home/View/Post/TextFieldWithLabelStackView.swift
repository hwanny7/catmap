//
//  CustomTextField.swift
//  Trigger
//
//  Created by yun on 2023/08/14.
//

import UIKit

enum TextType {
    case field
    case view
}

final class TextFieldWithLabelStackView: UIStackView {
    
    private let title: String
    private let placeholderText: String
    private let textType: TextType
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = placeholderText
        label.textColor = .lightGray
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholderText
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 10.0
        textField.returnKeyType = .done
        textField.isEnabled = false
        return textField
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return textView
    }()
    
    
    init(title: String, placeholderText: String, textType: TextType) {
        self.title = title
        self.placeholderText = placeholderText
        self.textType = textType
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        axis = .vertical
        alignment = .fill
        spacing = 8
        translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(descriptionLabel)
        
        switch textType {
        case .field:
            addArrangedSubview(descriptionTextField)
            let image = UIImageView(image: UIImage(systemName: "chevron.right"))
            image.translatesAutoresizingMaskIntoConstraints = false
            descriptionTextField.addSubview(image)
            NSLayoutConstraint.activate([
                image.trailingAnchor.constraint(equalTo: descriptionTextField.trailingAnchor, constant: -8),
                image.centerYAnchor.constraint(equalTo: descriptionTextField.centerYAnchor),
            ])
            descriptionTextField.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        case .view:
            addArrangedSubview(descriptionTextView)
            descriptionTextView.addSubview(placeholderLabel)
            NSLayoutConstraint.activate([
                placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 16),
                placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 21),
            ])
            descriptionTextView.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        }
    }
    
    private func isContentEmpty(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

// MARK: - UITextView deleagte

extension TextFieldWithLabelStackView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        isContentEmpty(textView)
    }
}
