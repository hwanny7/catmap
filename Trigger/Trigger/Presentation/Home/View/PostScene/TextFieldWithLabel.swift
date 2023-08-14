//
//  CustomTextField.swift
//  Trigger
//
//  Created by yun on 2023/08/14.
//

import UIKit

class TextFieldWithLabel: UIStackView, UITextFieldDelegate {
    
    private let title: String
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
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
        textField.placeholder = "게시글 내용을 작성해 주세요."
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 10.0
//        textField.delegate = self
        return textField
    }()
    
//    let descriptionTextField = UITextField =
    
    
    init(frame: CGRect,title: String) {
        self.title = title
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        axis = .vertical
        alignment = .fill
        spacing = 8
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        addSubview(descriptionTextField)
        
        NSLayoutConstraint.activate([
            descriptionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/6),
            descriptionTextField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 5/6),
        ])
        
    }
}
