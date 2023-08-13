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


    private lazy var phPicker: UIViewController? = {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 0
            let phpPicker = PHPickerViewController(configuration: configuration)
            phpPicker.delegate = self
            return phpPicker
        } else {
            return nil
        }
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
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
    
    private func openLibrary() {
        if #available(iOS 14.0, *) {
            present(phPicker!, animated: true)
        } else {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
    }
    
    private func openCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
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

// MARK: - PHPicker delegate

@available(iOS 14, *)
extension CreatePostViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
}
