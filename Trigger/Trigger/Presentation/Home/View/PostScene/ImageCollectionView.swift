import UIKit
import PhotosUI

class ImageCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    weak var parentViewController: (UIViewController & Alertable)?
    
    private var viewModel: DefaultPostViewModel
    

    init(parentViewController: (UIViewController & Alertable)?, viewModel: DefaultPostViewModel) {
        self.parentViewController = parentViewController
        self.viewModel = viewModel
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: layout)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        delegate = self
        dataSource = self
        backgroundColor = .white
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        addGestureRecognizer(gesture)
        
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {

        switch gesture.state {
        case .began:
            guard let targetIndexPath = indexPathForItem(at: gesture.location(in: self)), targetIndexPath.row != 0 else { return }
            beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            if let targetIndexPath = indexPathForItem(at: gesture.location(in: self)), targetIndexPath.row == 0 {
                cancelInteractiveMovement()
                // 마지막 범위 못 벗어나도록 다시 설정하기
                // nil 값일 때도 막도록 설정해야함
            } else {
                updateInteractiveMovementTargetPosition(gesture.location(in: self))
            }
        case .ended:
            guard let _ = indexPathForItem(at: gesture.location(in: self)) else {
                cancelInteractiveMovement()
                return
            }
            endInteractiveMovement()
        default:
            cancelInteractiveMovement()
        }
    }
    
    
    // MARK: - Handling tap event
    
    @objc func didTapCameraButton() {
        guard let viewController = parentViewController else { return }
        
        if viewModel.canUploadImage {
            let libraryAction = UIAlertAction(title: "사진앨범", style: .default) { _ in
                self.openLibrary()
            }
            let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
                self.openCamera()
            }
            viewController.showAlert(actions: [libraryAction, cameraAction], preferredStyle: .actionSheet)
        } else {
            viewController.showAlert(title: "알림", message: "이미지는 최대 10장까지 첨부할 수 있어요.")
        }
    }
    
    @objc func didTapCancleButton(_ sender: UIButton) {
        guard let cell = sender.superview as? UICollectionViewCell,
              let indexPath = indexPath(for: cell) else { return }
        let index = indexPath.row
        viewModel.removeImage(index)
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
}

// MARK: - Data source

extension ImageCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageList.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cell 스타일 설정
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 10.0
        cell.clipsToBounds = true
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.gestureRecognizers?.forEach { cell.removeGestureRecognizer($0) }
        // 이전 셀에 추가되었던 이미지와 제스쳐 삭제
        
        // 이미지뷰 생성
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        let image = viewModel.imageList[indexPath.row]
        imageView.image = image
        
        // X 버튼 생성
        
        cell.addSubview(imageView)

        if indexPath.row == 0 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton))
            cell.addGestureRecognizer(tapGesture)
            
            let countLabel = UILabel()
            countLabel.translatesAutoresizingMaskIntoConstraints = false
            countLabel.text = "\(viewModel.numberOfPhotos)/\(viewModel.photoUploadLimit)"
            countLabel.textColor = .black
            countLabel.font = UIFont.systemFont(ofSize: 10)
            
            let stackView = UIStackView(arrangedSubviews: [imageView, countLabel])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            
            cell.addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            ])
            
        } else {
            let cancelButton = UIButton(type: .custom)
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            cancelButton.tintColor = .white
            cancelButton.addTarget(self, action: #selector(didTapCancleButton(_:)), for: .touchUpInside)
            
            cell.addSubview(cancelButton)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: cell.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                
                cancelButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                cancelButton.topAnchor.constraint(equalTo: cell.topAnchor),
            ])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.size.width/5,
                      height: frame.size.height)
    }
    
    // MARK: - Method for moving
    
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        let index = indexPath.row
//
//        if index == 0 {
//            return false
//        } else {
//            return true
//        }
//    }

    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = viewModel.imageList.remove(at: sourceIndexPath.row)
        viewModel.imageList.insert(item, at: destinationIndexPath.row)
    }
}

// MARK: - Image picker delegate


extension ImageCollectionView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private func openLibrary() {
        guard let viewController = parentViewController else { return }
        
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = viewModel.maxPhotoUploadCount
            let phpPicker = PHPickerViewController(configuration: configuration)
            phpPicker.delegate = self
            viewController.present(phpPicker, animated: true)
        } else {
            imagePicker.sourceType = .photoLibrary
            viewController.present(imagePicker, animated: true)
        }
    }
    
    private func openCamera() {
        guard let viewController = parentViewController else { return }
        
        imagePicker.sourceType = .camera
        viewController.present(imagePicker, animated: true)
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
extension ImageCollectionView: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        results.forEach { itemProvider in
            let isLoadPossible = itemProvider.itemProvider.canLoadObject(ofClass: UIImage.self)
            if isLoadPossible {
                itemProvider.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    guard let image = image as? UIImage else { return}
                    self.viewModel.appendImage(image)
                    DispatchQueue.main.async {
                        self.reloadData()
                    }
                }
            } else {
                print("load가 불가능합니다.")
            }
        }
    }
}
