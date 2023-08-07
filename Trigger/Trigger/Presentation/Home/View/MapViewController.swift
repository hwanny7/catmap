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
    
    let coordinate = CLLocationCoordinate2D(latitude: 40.728, longitude: -74)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.showsUserLocation = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        map.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        
        
        addCustomPin()
    }
    
    
    static func create(
//        with viewModel: MoviesListViewModel,
//        posterImagesRepository: PosterImagesRepository?
    ) -> MapViewController {
        let view = MapViewController.instantiateViewController()
//        view.viewModel = viewModel
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
}
