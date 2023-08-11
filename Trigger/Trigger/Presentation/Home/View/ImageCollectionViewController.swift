import UIKit

class ImageCollectionViewController: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var colors: [UIColor] = [
        .link,
        .red,
        .systemPink,
        .systemBlue,
        .systemGray,
        .systemBlue,
        .systemGray,
    ]

    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 0
        super.init(frame: frame, collectionViewLayout: layout)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
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
                // 옮기고자 하는 곳의 인덱스가 0인 경우에 이동 취소
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
}

extension ImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.size.width/4,
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
