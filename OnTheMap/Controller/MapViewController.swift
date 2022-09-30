//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 21/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addLocation: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    
    var annotations = [MKPointAnnotation]()
    let reuseId = "pin"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // data that you can download from parse.
        OTMUser.getStudentMapPoints(completion: {(success, error) in
            if success {
                DispatchQueue.main.async {
                    self.generatePointAnnotations()
                }
            } else {
                self.showErrorAlert(title: "Error!", message: error?.localizedDescription ?? "Download Failed")
            }
        })
    }
    
    
    @IBAction func addLocation(_ sender: Any) {
        performSegue(withIdentifier: "addLocation", sender: sender)
    }
    
    func generatePointAnnotations() {
        for location in studentInformationModel.locationResults {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D (latitude: lat, longitude: long)
            
            let pointAnnotation = MKPointAnnotation()
            let name = "\(location.firstName) \(location.lastName)"
            pointAnnotation.title = name
            pointAnnotation.subtitle = location.mediaURL
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotation(pointAnnotation)

        }
    }
    
    func showErrorAlert(title: String, message: String) {
           let alertViewController = UIAlertController (title: title,  message: message, preferredStyle: .alert)
           alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alertViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        OTMUser.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
 
    // MARK: - MKMapViewDelegate
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
            
        return pinView
    }
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.canOpenURL(URL(string: toOpen)!)
            } else {
                showErrorAlert(title: "Error!", message: "Unable to open the URL")
            }
        }
    }
}
