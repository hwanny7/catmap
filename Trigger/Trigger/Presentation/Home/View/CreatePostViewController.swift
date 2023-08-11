//
//  CreatePostViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit

class CreatePostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
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
        view.addSubview(ImageCollectionViewController(frame: view.frame))
    }
    
    
    

    // MARK: - Handle gesture
    

}

