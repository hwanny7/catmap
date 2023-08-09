//
//  CreatePostViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit

class CreatePostViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var cameraButton: UIView!
    
    private var viewModel: DefaultPostViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton))
        cameraButton.addGestureRecognizer(tapGesture)
    }
    

    static func create(
        with viewModel: DefaultPostViewModel
    ) -> CreatePostViewController {
        let view = CreatePostViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    @objc func didTapCameraButton() {
        print("Tap!")
    }

}
