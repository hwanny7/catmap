//
//  GoogleMapViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/07.
//

import UIKit

class GoogleMapViewController: UIViewController, StoryboardInstantiable {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func create(
//        with viewModel: MoviesListViewModel,
//        posterImagesRepository: PosterImagesRepository?
    ) -> GoogleMapViewController {
        let view = GoogleMapViewController.instantiateViewController()
//        view.viewModel = viewModel
//        view.posterImagesRepository = posterImagesRepository
        return view
    }
    
}
