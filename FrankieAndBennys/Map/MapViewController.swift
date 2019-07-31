//
//  MapViewController.swift
//  FrankieAndBennys
//
//  Created by Yogesh N Ramsorrrun on 27/07/2019.
//  Copyright © 2019 Yogesh N Ramsorrrun. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet fileprivate weak var mapView: MKMapView!
    fileprivate let regionRadius: CLLocationDistance = 1000
    fileprivate let identifier = "annotationID"
    fileprivate let presenter: MapPresenterContract
    fileprivate var restaurants: [Restaurant]?
    
    init(presenter: MapPresenterContract) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: identifier)
        presenter.retrieveRestaurantData()
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

extension MapViewController: MapViewContract {
    func showRestaurants(_ restaurants: [Restaurant]) {
        self.restaurants = restaurants
        restaurants.forEach {
            mapView.addAnnotation($0)
        }
        if let region  = MKCoordinateRegion(coordinates: restaurants.map{ $0.coordinate } ) {
            mapView.setRegion(region, animated: true)
        } else {
            showLoadingFail()
        }
    }
    
    func showLoadingFail() {
        let alert = UIAlertController(title: "Loading Error", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension MapViewController:  MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let restaurantAnnotation = annotation as? Restaurant else { return nil }
        
        guard let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView else {
            fatalError("Failed to load annotationView")
        }
        dequeuedView.canShowCallout = true
        dequeuedView.calloutOffset = CGPoint(x: -5, y: 5)
        dequeuedView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        dequeuedView.annotation = restaurantAnnotation
        return dequeuedView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let restaurant = view.annotation as? Restaurant else { return }
        
        let presenter = RestaurantDetailsPresenter()
        let vc = RestaurantDetailsViewController(presenter: presenter, restaurant: restaurant)
        presenter.view = vc
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.barTintColor = .red
        present(navVC, animated: true, completion: nil)
    }
}
