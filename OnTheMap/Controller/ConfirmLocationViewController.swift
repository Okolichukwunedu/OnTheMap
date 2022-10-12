//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 23/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var addLink: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var confirmMapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var location: location?
    var mapLocation = MKPointAnnotation()
    let reusedId = "pin"
    
    //MARK: Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        addLink.delegate = self
        self.confirmMapView.delegate = self
        activityIndicator.isHidden = true
        getMapInformation()
    }
    
    func getMapInformation() {
        mapLocation.coordinate = self.location
        mapLocation.title = location?.firstName
        mapLocation.subtitle = self.addLink.text!
        let region = MKCoordinateRegion(center: self.location, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        confirmMapView.addAnnotation(mapLocation)
        confirmMapView.setRegion(region, animated: true)
        confirmMapView.setCenter(location, animated: false)
        confirmMapView.regionThatFits(region)
    }
    
    // MARK: Add or Update location
    @IBAction func Submit( sender: Any) {
        OTMUser.getUserInformation (completion: {(OTMUserResult, error) in
            guard let OTMUserResult = OTMUserResult else {
                self.showErrorAlert(title: "Error!", message: "Unable to get user information")
                return
            }
            let studentLocationRequest = PostStudentLocation(uniqueKey: OTMUserResult.accountKey, firstName: OTMUserResult.firstName, lastName: OTMUserResult.lastName, mapString: self.location?.mapString ?? "", mediaURL: self.addLink.text!, latitude: self.location.latitude, longitude: self.location.longitude)
            self.postLocationpostRequest(postRequest: studentLocationRequest)
            self.performSegue(withIdentifier: "toMap", sender: self)
        })
    }
    
    func postLocationpostRequest(postRequest: PostStudentLocation) {
        OTMUser.postStudentLocation(postRequest: postRequest, completion: {(postResponse, error) in
            guard postResponse != nil else {
                self.showErrorAlert(title: "Error!", message: "Failed to add new location")
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
    
        
    func showErrorAlert(title: String, message: String) {
        let alertViewController = UIAlertController (title: title,  message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Error", style: .default, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    // MARK: Loading state
    func setLoading(_ loading: Bool) {
        if loading {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.submitButton.isEnabled = !loading
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusedId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusedId)
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
    
extension ConfirmLocationViewController {
    
    //MARK: Functions for the Keyboard Notifications
       @objc func keyboardWillShow(_ notification: Notification) {
           if addLink.isEditing {
               view.frame.origin.y = -getKeyboardHeight(notification)
           }
       }
       
       @objc func keyboardWillHide(_ notification: Notification) {
           if view.frame.origin.y != 0 {
               view.frame.origin.y = 0
           }
       }
       
       func getKeyboardHeight(_ notification: Notification) -> CGFloat {
           let userInfo = notification.userInfo
           let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
           return keyboardSize.cgRectValue.height
       }
       
       func subscribeToKeyboardNotifications () {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
       func unsubscribeToKeyboardNotifications () {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
}
