//
//  CreatePostViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit
import PhotosUI


@IBDesignable
class CreatePostViewController: UIViewController, Alertable {

    private lazy var picker: Any? = {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            return PHPickerViewController(configuration: configuration)
        } else {
            return UIImagePickerController()
        }
    }()
    
    private var viewModel: DefaultPostViewModel
    
    private var scrollView: UIScrollView!
    
    private var collectionView: UICollectionView!
    
    
    init(with viewModel: DefaultPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func openCameraOption() {
        let libraryAction = UIAlertAction(title: "사진앨범", style: .default) { _ in
            self.openLibrary()
        }
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
            self.openCamera()
        }
        showAlert(actions: [libraryAction, cameraAction], preferredStyle: .actionSheet)
    }
    
    
    func setupView() {
        view.backgroundColor = .white

        let imageCollectionView = ImageCollectionViewController(frame: view.frame, openCameraOption: openCameraOption)
        view.addSubview(imageCollectionView)
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: imageCollectionView.widthAnchor, multiplier: 1/5)
        ])
    }
    
    
    
}

extension CreatePostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func openLibrary() {
        if #available(iOS 14.0, *) {
            let phpPicker = picker as! PHPickerViewController
            present(phpPicker, animated: true)
        } else {
            let imagePicker = picker as! UIImagePickerController
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
    }
    
    func openCamera() {
//        picker.sourceType = .camera
//        present(picker, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let _ = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        // edit image는 크기가 작아지니까 orginal이랑 크기 차이가 얼마나 나는지 확인하기
    }
}

@available(iOS 14, *)
extension CreatePostViewController: PHPickerViewControllerDelegate {
    
    
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        <#code#>
    }
    
    
}
