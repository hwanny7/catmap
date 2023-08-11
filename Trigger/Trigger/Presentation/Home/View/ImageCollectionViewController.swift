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
        layout.itemSize = CGSize(width: frame.size.width/2.5, height: frame.size.width/2.5)
        
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        delegate = self
        dataSource = self
        backgroundColor = .black
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {

        switch gesture.state {
        case .began:
            guard let targetIndexPath = indexPathForItem(at: gesture.location(in: self)) else { return }
            beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            updateInteractiveMovementTargetPosition(gesture.location(in: self))
        case .ended:
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
        return CGSize(width: frame.size.width/3.2,
                      height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = colors.remove(at: sourceIndexPath.row)
        colors.insert(item, at: destinationIndexPath.row)

        // 실제 아이템의 위치도 변경해줘야 그 자리를 유지한다.
    }
}
