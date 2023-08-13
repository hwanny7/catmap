import UIKit
import PhotosUI

class ImageCollectionViewController: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    weak var parentViewController: (UIViewController & Alertable)?
    
    var colors: [UIColor] = [
        .link,
        .red,
        .systemPink,
        .systemBlue,
        .systemGray,
        .systemBlue,
        .systemGray,
    ]


    init(frame: CGRect, parentViewController: (UIViewController & Alertable)?) {
        self.parentViewController = parentViewController
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: frame, collectionViewLayout: layout)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        delegate = self
        dataSource = self
        backgroundColor = .white
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        addGestureRecognizer(gesture)
        
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        print(gesture.location(in: self))
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
    
    @objc func didTapCameraButton() {
        guard let viewController = parentViewController else { return }
        
        let libraryAction = UIAlertAction(title: "사진앨범", style: .default) { _ in
            self.openLibrary()
        }
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
            self.openCamera()
        }
        viewController.showAlert(actions: [libraryAction, cameraAction])
    }
}

extension ImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        let image = UIImage(systemName: "camera")
        imageView.image = image
        
        cell.addSubview(imageView)
        
        if indexPath.row == 0 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton))
            imageView.addGestureRecognizer(tapGesture)
            imageView.isUserInteractionEnabled = true
        }
        
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])
        
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
        
        let item = colors.remove(at: sourceIndexPath.row)
        colors.insert(item, at: destinationIndexPath.row)
        // 실제 아이템의 위치도 변경해줘야 그 자리를 유지한다.
    }
}

extension ImageCollectionViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private func openLibrary() {
        guard let viewController = parentViewController else { return }
        
        if #available(iOS 14.0, *) {
            viewController.present(phPicker!, animated: true)
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
extension ImageCollectionViewController: PHPickerViewControllerDelegate {

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
