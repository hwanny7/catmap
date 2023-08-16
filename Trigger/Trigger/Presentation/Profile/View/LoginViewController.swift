//
//  LoginViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/16.
//

import UIKit

class LoginViewController: UITableViewController {

    private let viewModel: LoginViewModel

    init(
        with viewModel: LoginViewModel
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
