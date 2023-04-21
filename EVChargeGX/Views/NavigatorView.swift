//
//  NavigatorView.swift
//  EVChargeGX
//
//  Created by iosdev on 21.4.2023.
//

import UIKit
import MapKit

class NavigatorView: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the map view
        mapView.delegate = self
        mapView.showsUserLocation = true

        // Create an annotation and add it to the map
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        annotation.title = "San Francisco"
        annotation.subtitle = "California"
        mapView.addAnnotation(annotation)

        // Set the map's region to focus on the annotation
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }

    // MARK: - MKMapViewDelegate methods

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
        } else {
            view?.annotation = annotation
        }

        return view
    }

}
