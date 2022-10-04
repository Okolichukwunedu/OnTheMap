//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 21/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var addLocation: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var locationCoordinate = CLLocationCoordinate2D()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocation.delegate = self
    }
    
    
    //MARK: Enter location
    @IBAction func enterButton(_ sender: UIButton){
        if (addLocation.text == nil || addLocation.text == " ") {
            showErrorAlert(title: "Error!", message: "Please enter your location")
            return
        }
        // MARK: New location in map
        let location = addLocation.text!
        setLoading(true)
        CLGeocoder().geocodeAddressString(location) { (data, error) in
            guard let data = data else {
                self.showErrorAlert(title: "Error!", message: "Cannot find this location: \(self.addLocation.text!)")
                return
            }
            self.locationCoordinate = (data.first?.location!.coordinate)!
            self.performSegue(withIdentifier: "addLink", sender: self)
        }
    }
    
    // MARK: Loading state
    func setLoading(_ loading: Bool) {
        if loading {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.enterButton.isEnabled = !loading
    }
    
    func showErrorAlert(title: String, message: String) {
        let alertViewController = UIAlertController (title: title,  message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Error", style: .default, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
        setLoading(false)
    }
}

extension AddLocationViewController {
    
    //MARK: Functions for the Keyboard Notifications
       @objc func keyboardWillShow(_ notification: Notification) {
           if addLocation.isEditing {
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
