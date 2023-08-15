//
//  MapCoordinateViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/15.
//

import UIKit

class MapCoordinateViewController: UIViewController {

    private var viewModel: DefaultCoordinateViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    init(with viewModel: DefaultCoordinateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        view.backgroundColor = .red
    }
    


}
