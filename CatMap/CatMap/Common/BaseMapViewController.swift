//
//  CustomMapViewController.swift
//  CatMap
//
//  Created by yun on 2023/08/15.
//

import UIKit
import MapKit
import CoreLocation

class BaseMapViewController: UIViewController, Alertable {
    let locationManager = CLLocationManager()
    let map = MKMapView()

    private var locationArray = [MKLocalSearchCompletion]()
    
    private lazy var locationCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    
    private let compassButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemIndigo
        button.backgroundColor = .white
        return button
    }()
    
    lazy var locationSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.backgroundColor = nil
        return searchBar
    }()
    
    private lazy var locationTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        view.addSubview(map)
        locationManager.delegate = self
        
        compassButton.addTarget(self, action: #selector(didTapCurrentLocationButton), for: .touchUpInside)
        map.addSubview(compassButton)
        
        NSLayoutConstraint.activate([
            compassButton.centerYAnchor.constraint(equalTo: map.centerYAnchor),
            compassButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            compassButton.widthAnchor.constraint(equalTo: map.widthAnchor, multiplier: 0.15),
            compassButton.heightAnchor.constraint(equalTo: compassButton.widthAnchor),
        ])
        setupSearchBarConstraint()
        addSubViews()
        addLocationTableView()
        requestAuthorizationForCurrentLocation()
    }
    
    func addSubViews() {
        
    }
    
    func addLocationTableView() {
        view.addSubview(locationTableView)
        NSLayoutConstraint.activate([
            locationTableView.topAnchor.constraint(equalTo: view.topAnchor),
            locationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupSearchBarConstraint() {
        map.addSubview(locationSearchBar)
    }
    
    func requestAuthorizationForCurrentLocation() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("첫번째!")
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            goTo(setting: .map)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    @objc private func didTapCurrentLocationButton() {
        requestAuthorizationForCurrentLocation()
    }
    
    private func centerMapOnUser(location: CLLocation) {
        let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        map.setRegion(region, animated: false)
    }
}

// MARK: - CLLocation manager delegate

extension BaseMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        centerMapOnUser(location: location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         switch status {
         case .authorizedAlways, .authorizedWhenInUse:
             print("사용자가 위치 설정에 동의했습니다.")
             locationManager.startUpdatingLocation()
         case .denied, .restricted:
             print("사용자가 위치 설정에 동의하지 않았습니다.")
         case .notDetermined:
                 print("위치 설정 권한이 아직 결정되지 않았습니다.")
         default:
             print("권한 설정 X")
         }
     }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}

// MARK: - Search bar delegate

extension BaseMapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            locationArray.removeAll()
        } else {
            locationCompleter.queryFragment = searchText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        locationArray.removeAll()
        locationTableView.isHidden = true
        navigationItem.titleView = nil
        navigationItem.hidesBackButton = false
        locationSearchBar.showsCancelButton = false
        setupSearchBarConstraint()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        navigationItem.titleView = locationSearchBar
        navigationItem.hidesBackButton = true
        locationSearchBar.showsCancelButton = true
        locationTableView.isHidden = false
        return true
    }
}

// MARK: - Table View delegate

extension BaseMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let location = locationArray[indexPath.row]
        cell.textLabel?.text = location.title
        return cell
    }
}

extension BaseMapViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        locationArray = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("자동완성 검색에 실패했습니다:", error.localizedDescription)
    }
}
