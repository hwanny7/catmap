//
//  FloatingButton.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit


let floatingButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    button.layer.masksToBounds = true
    button.layer.cornerRadius = 30
    button.backgroundColor = .systemIndigo
    
    let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
    
//    button.layer.shadowRadius = 10
//    button.layer.shadowOpacity = 0.3
    button.setImage(image, for: .normal)
    button.tintColor = .white
    button.setTitleColor(.white, for: .normal)
    return button
    
}()

