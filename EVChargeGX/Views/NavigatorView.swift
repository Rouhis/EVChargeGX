//
//  NavigatorView.swift
//  EVChargeGX
//
//  Created by iosdev on 21.4.2023.
//

import UIKit
import MapKit
import SwiftUI

class NavigatorView: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
                label.font = UIFont.preferredFont(forTextStyle: .title1)
                label.text = "Hello, UIKit!"
                label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(label)
        NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                    label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                ])
        // Set up the map view
        if mapView == nil {
            print(":D", mapView)
        } else {
            mapView.delegate = self
            mapView.showsUserLocation = true
        }
        // Create an annotation and add it to the map
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        annotation.title = "San Francisco"
        annotation.subtitle = "California"
        if mapView == nil {
            print(":D", mapView)
        } else {
            mapView.addAnnotation(annotation)
        }
        
        // Set the map's region to focus on the annotation
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        if mapView == nil {
            print(":D", mapView)
        } else {
            mapView.setRegion(region, animated: true)
        }
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

struct MyView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> NavigatorView {
        let vc = NavigatorView()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: NavigatorView, context: Context) {
        
    }
    
}
