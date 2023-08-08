//
//  GoogleMapViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/07.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var map: MKMapView!
    
    private let locationManager = CLLocationManager()
    private var viewModel: DefaultMapViewModel!
    
    let coordinate = CLLocationCoordinate2D(latitude: 40.728, longitude: -74)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.showsUserLocation = true
        locationManager.delegate = self
        requestAuthorizationForCurrentLocation()
        
        addCustomPin()
    }
    
    
    static func create(
        with viewModel: DefaultMapViewModel
//        posterImagesRepository: PosterImagesRepository?
    ) -> MapViewController {
        let view = MapViewController.instantiateViewController()
        view.viewModel = viewModel
//        view.posterImagesRepository = posterImagesRepository
        return view
    }
    
    private func addCustomPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Bug"
        pin.subtitle = "Go and catch them all"
        map.addAnnotation(pin)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        // User의 위치 표시 마커는 변경하지 않는다. 원하면 변경하는 것도 가능할 듯?

        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        // tableView처럼 캐시를 사용해서 메모리를 효율적으로 사용한다.

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
//            annotationView?.rightCalloutAccessoryView => 더 자세한 페이지 보여주는 거인 듯
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(systemName: "house")

        return annotationView
    }
    
    // mapView func은 addCustomPin을 커스텀해서 이쁜 View로 보여준다.
}

// MARK: - Delegate CLLocationManager

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        // Get the user's current location from the locations array
        let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // Set the region for the map to center on the user's location
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(region, animated: true)
        
        // You can also add a custom annotation (e.g., a marker) for the user's location on the map if needed
        // let annotation = MKPointAnnotation()
        // annotation.coordinate = userLocation
        // mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
         switch status {
         case .authorizedAlways, .authorizedWhenInUse:
             print("GPS 권한 설정됨")
             locationManager.startUpdatingLocation()
             // didUpdate 호출
         case .restricted, .notDetermined:
             print("GPS 권한 설정되지 않음")
         case .denied:
             print("GPS 권한 요청 거부됨")
         default:
             print("GPS: Default")
         }
     }
    
    private func requestAuthorizationForCurrentLocation() {
        
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
            print("거절인데요!")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }
}
