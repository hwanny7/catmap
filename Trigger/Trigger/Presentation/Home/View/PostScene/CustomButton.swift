//
//  CustomButton.swift
//  Trigger
//
//  Created by yun on 2023/08/14.
//

import UIKit


final class searchLocationButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        setTitle("위치 검색", for: .normal)
        backgroundColor = .brown
        layer.borderColor = UIColor.gray.cgColor
        contentHorizontalAlignment = .left
        setImage(UIImage(systemName: "chevron.right"), for: .normal)
        tintColor = .gray
        translatesAutoresizingMaskIntoConstraints = false
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let imageView = imageView else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
