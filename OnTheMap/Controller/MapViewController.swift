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
    
    var annotations = [MKPointAnnotation] ()
    
    @IBOutlet weak var mapView: MKMapView!
    

    @IBAction func refresh(_ sender: Any) {
        viewDidLoad()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // data that you can download from parse.
        OTMUser.getStudentMapPoints { (DataInfo, error) in
            if error == nil {
                DispatchQueue.main.async {
                    StudentDataInfo.sharedInstance().students = DataInfo ?? []
                    self.generatePointAnnotations()
                }
            } else {
                self.showErrorAlert(message: "Try again!")
            }
        }
    }
    
    func generatePointAnnotations() {
        for studentDetail in StudentDataInfo.sharedInstance().students {
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: studentDetail.latitude ?? 0.0, longitude: studentDetail.longitude ?? 0.0)
            let name = studentDetail.firstName + " " + studentDetail.lastName
            pointAnnotation.title = name
            pointAnnotation.subtitle = studentDetail.mediaURL ?? " "
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotation(pointAnnotation)
        }
    }
    
    func showErrorAlert(message: String) {
           let alertViewController = UIAlertController (title: "Error",  message: message, preferredStyle: .alert)
           alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alertViewController, animated: true)
    }
       
    @IBAction func logout(_ sender: UIButton) {
           LogOutRequest.logout(completion: handleLogoutRequest(success: error:))
    }
       
    func handleLogoutRequest(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            showErrorAlert(message: "Loggin out failed. Try again!")
        }
    }
        
    
    // MARK: - MKMapViewDelegate
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
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
            }
        }
    }
}
