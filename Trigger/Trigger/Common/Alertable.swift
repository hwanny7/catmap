//
//  Alertable.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit

enum setting: String {
    case camera = "카메라"
    case map = "지도"
}


protocol Alertable {
    
}

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
    
    func goTo(setting: setting) {
        let message = "\(setting.rawValue) 서비스를 사용할 수 없습니다. 기기의 설정에서 \(setting.rawValue) 서비스를 켜주세요."
        let action = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        showAlert(actions: [action], message: message)
    }

}
