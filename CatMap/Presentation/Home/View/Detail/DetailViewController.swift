//
//  DetailViewController.swift
//  CatMap
//
//  Created by yun on 2023/08/29.
//

import UIKit



final class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModel
    
    init(with viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .red
    }
    
    
}



