//
//  ATMMapViewController.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import UIKit
import MapKit

final class ATMMapViewController: UIViewController {

    private let viewModel: ATMMapViewModel

    private lazy var mapView: MKMapView = MKMapView()

    init(viewModel: ATMMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ATM Location"

        mapView.register(ATMAnnotationView.self, forAnnotationViewWithReuseIdentifier:MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.accessibilityIdentifier = "\(ATMMapViewController.self).mapView"

        view.addSubview(mapView)
        mapView.pin(to: view, ignoreSafeArea: true)
        mapView.delegate = self
        
        let coordinateRegion = MKCoordinateRegion(
            center: viewModel.atmAnnotation.coordinate,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(viewModel.atmAnnotation)
    }
}

extension ATMMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard
            let annotation = annotation as? ATMAnnotation,
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? ATMAnnotationView
        else {
            return nil
        }
        
        annotationView.annotation = annotation
        annotationView.accessibilityIdentifier = "\(ATMMapViewController.self).annotationView"

        return annotationView
    }
}

final class ATMAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            image = UIImage(named: "findUsATM")
        }
    }
}
