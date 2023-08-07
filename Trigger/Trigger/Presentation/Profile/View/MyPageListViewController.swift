//
//  MyPageListViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/07.
//

import UIKit

class MyPageListViewController: UITableViewController, StoryboardInstantiable {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MyPage"
    }
    
    static func create(
//        with viewModel: MoviesListViewModel,
//        posterImagesRepository: PosterImagesRepository?
    ) -> MyPageListViewController {
        let view = MyPageListViewController.instantiateViewController()
//        view.viewModel = viewModel
//        view.posterImagesRepository = posterImagesRepository
        return view
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
