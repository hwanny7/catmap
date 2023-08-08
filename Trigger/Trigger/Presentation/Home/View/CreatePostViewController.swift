//
//  CreatePostViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit

class CreatePostViewController: UIViewController, StoryboardInstantiable {

    private var viewModel: DefaultPostViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    static func create(
        with viewModel: DefaultPostViewModel
    ) -> CreatePostViewController {
        let view = CreatePostViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }

}
