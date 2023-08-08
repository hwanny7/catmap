//
//  PickerController.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit

class PickerController: UIImagePickerController {

    // MARK: - Init 부분이 안 되는 것 같음. 만약에 여기서 MapViewController의 method가 필요하지 않는다면 다시 시도해보자
    init() {
        super.init(nibName: nil, bundle: nil)
        print("hello")
        sourceType = .camera
        allowsEditing = true
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension PickerController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
    }


}
