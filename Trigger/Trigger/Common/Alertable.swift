//
//  Alertable.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit



protocol Alertable {}
extension Alertable where Self: UIViewController{
    
    func showAlert(
        actions: [UIAlertAction] = [],
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert
//        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { alert.addAction($0) }
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

}
