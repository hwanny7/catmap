//
//  MyPageListViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/07.
//

import UIKit

class MyPageViewController: UITableViewController, StoryboardInstantiable {

    private let viewModel: DefaultMyPageViewModel

    init(
        with viewModel: DefaultMyPageViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
