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

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var addLink: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var confirmMapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newLocation: DataInfo?
    var newData: StudentInformation?
    
    //Map Data

    
    //MARK: Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.confirmMapView.delegate = self
        getLocation()
    }
    
    func getLocation() {
        if let studentLocation = newLocation {
            let studentLocation = newStudentLocation(
                
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mediaURL: studentLocation.mediaURL,
                uniqueKey: studentLocation.uniqueKey,
                objectId: studentLocation.objectId ,
                mapString: studentLocation.mapString,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: studentLocation.createdAt ?? "",
                updatedAt: studentLocation.updatedAt ?? ""
            )
            showLocations(location: studentLocation)
        }
    }
    
    // MARK: Add or Update location
    @IBAction func Submit( sender: Any) {
        if let newStudentLocation = newLocation {
            if OTMUser.Auth.uniqueKey == "" {
                    OTMUser.addLocation(information: newStudentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.setLoading(true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showErrorAlert(message: "Something went wrong")
                                self.setLoading(false)
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: Cancel out of adding location
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: New location in map
    func showLocations(location: newStudentLocation) {
        confirmMapView.removeAnnotations(confirmMapView.annotations)
        if let coordinate = extractCoordinate(location: newLocation) {
            let annotation = MKPointAnnotation()
            annotation.title = newData?.firstName
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            confirmMapView.addAnnotation(annotation)
            confirmMapView.showAnnotations(confirmMapView.annotations, animated: true)
        }
    }
    
    func extractCoordinate(location: DataInfo?) -> CLLocationCoordinate2D? {
        if let lat = newLocation?.latitude, let lon = newLocation?.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    func showErrorAlert(message: String) {
           let alertViewController = UIAlertController (title: "Error",  message: message, preferredStyle: .alert)
           alertViewController.addAction(UIAlertAction(title: "Error", style: .default, handler: {(action: UIAlertAction) in
           }))
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
