//
//  CustomMapViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/15.
//

import UIKit
import MapKit
import CoreLocation

class BaseMapViewController: UIViewController, Alertable {
    let locationManager = CLLocationManager()
    let map = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        view.addSubview(map)
        locationManager.delegate = self
        requestAuthorizationForCurrentLocation()
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
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            let title = "Location Access Denied"
            let message = "To use this app, please enable location access in Settings."
            let action = UIAlertAction(title: "설정", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
            showAlert(actions: [action], title: title, message: message)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension BaseMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Get the user's current location from the locations array
        let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        // Set the region for the map to center on the user's location
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        map.setRegion(region, animated: false)
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error requesting location: \(error.localizedDescription)")
    }
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
         switch status {
         case .authorizedAlways, .authorizedWhenInUse:
             locationManager.startUpdatingLocation()
         case .restricted, .notDetermined:
             print("GPS 권한 설정되지 않음")
         case .denied:
             print("GPS 권한 요청 거부됨")
         default:
             print("GPS: Default")
         }
     }
    
}
