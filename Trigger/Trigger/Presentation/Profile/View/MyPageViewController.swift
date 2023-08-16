//
//  MyPageListViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/07.
//

import UIKit

final class MyPageViewController: UITableViewController {

    private let viewModel: MyPageViewModel

    init(
        with viewModel: MyPageViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        view.backgroundColor = .red
    }
    
    // MARK: - Table view data source

}
