//
//  Alertable.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit

protocol Alertable {}
extension Alertable where Self: UIViewController {
    
    func showAlert(
        title: String = "",
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        action: UIAlertAction
//        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
