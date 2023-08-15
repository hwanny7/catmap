//
//  MapCoordinateViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/15.
//

import UIKit
import MapKit
import CoreLocation

class MapCoordinateViewController: BaseMapViewController {

    private var viewModel: DefaultCoordinateViewModel
    
    init(with viewModel: DefaultCoordinateViewModel) {
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
    
    override func setupViews() {
        super.setupViews()
    
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        textLabel.text = "어디서 만난 고양이인가요? \n이웃들과 공유해주세요. 🐈‍⬛"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let markerImageView = UIImageView(image: UIImage(named: "marker"))
        markerImageView.translatesAutoresizingMaskIntoConstraints = false
        map.addSubview(markerImageView)
        
        NSLayoutConstraint.activate([
            markerImageView.centerXAnchor.constraint(equalTo: map.centerXAnchor),
            markerImageView.centerYAnchor.constraint(equalTo: map.centerYAnchor)
        ])
        
        let squareButton = UIButton(type: .system)
        squareButton.translatesAutoresizingMaskIntoConstraints = false
        squareButton.setTitle("선택 완료", for: .normal)
        squareButton.backgroundColor = .blue
        squareButton.layer.cornerRadius = 10.0
        squareButton.tintColor = .white
        map.addSubview(squareButton)
        squareButton.addTarget(self, action: #selector(getCenterCoordinate), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            squareButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            squareButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            squareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            squareButton.heightAnchor.constraint(equalTo: map.heightAnchor, multiplier: 1/14)
        ])
    }
  
    @objc private func getCenterCoordinate() {
        let centerCoordinate = map.centerCoordinate
        viewModel.didSelect(coordinate: centerCoordinate)
    }
}




