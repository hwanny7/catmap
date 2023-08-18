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
    private var isFirstLocationUpdate = true
    private var locationArray = [String]()
    private let CountryArray = [
        "미국", "캐나다", "영국", "프랑스", "독일",
        "일본", "중국", "한국", "브라질", "호주",
        "이탈리아", "스페인", "인도", "러시아", "멕시코",
        "인도네시아", "터키", "사우디아라비아", "남아프리카", "아르헨티나",
        "콜롬비아", "페루", "이란", "칠레", "태국",
        "베네수엘라", "말레이시아", "이스라엘", "이집트", "그리스"
    ]
    
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
        map.addSubview(locationTableView)
        NSLayoutConstraint.activate([
            locationTableView.topAnchor.constraint(equalTo: map.topAnchor),
            locationTableView.leadingAnchor.constraint(equalTo: map.leadingAnchor),
            locationTableView.trailingAnchor.constraint(equalTo: map.trailingAnchor),
            locationTableView.bottomAnchor.constraint(equalTo: map.bottomAnchor),
        ])
    }
    
    func setupSearchBarConstraint() {
        map.addSubview(locationSearchBar)
        NSLayoutConstraint.activate([
            locationSearchBar.topAnchor.constraint(equalTo: map.topAnchor),
            locationSearchBar.leadingAnchor.constraint(equalTo: map.leadingAnchor),
            locationSearchBar.trailingAnchor.constraint(equalTo: map.trailingAnchor),
        ])
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
            locationArray = CountryArray.filter { $0.hasPrefix(searchText) }
            locationTableView.reloadData()
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
        cell.textLabel?.text = locationArray[indexPath.row]
        return cell
    }
}
