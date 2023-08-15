//
//  CustomTextField.swift
//  Trigger
//
//  Created by yun on 2023/08/14.
//

import UIKit

final class TextFieldWithLabelStackView: UIStackView {
    
    private let title: String
    private let placeholderText: String
    
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
        textField.delegate = self
        return textField
    }()
    
    
    init(title: String, placeholderText: String) {
        self.title = title
        self.placeholderText = placeholderText
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
        addArrangedSubview(descriptionTextField)
        descriptionTextField.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
    }
    
    func addImageViewOnRightSide(imageName: String) {
        descriptionTextField.isEnabled = false
        let image = UIImageView(image: UIImage(systemName: imageName))
        image.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.addSubview(image)
        NSLayoutConstraint.activate([
            image.trailingAnchor.constraint(equalTo: descriptionTextField.trailingAnchor, constant: -8),
            image.centerYAnchor.constraint(equalTo: descriptionTextField.centerYAnchor),
        ])
    }
    
}

extension TextFieldWithLabelStackView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
    }
}
