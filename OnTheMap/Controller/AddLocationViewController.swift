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

    var objectId: String?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocation.delegate = self
    }
    
    func geocode(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                var location: CLLocation?
                    if let marker = newMarker, marker.count > 0 {
                        location = marker.first?.location
                        var studentLocation = DataInfo.self
                    }
            }
        }
    }
    
    //MARK: Enter location
    @IBAction func enterButton(_ sender: UIButton){          geocode(newLocation: addLocation.text ?? "")
    }
    
    
    func showErrorAlert(message: String) {
           let alertViewController = UIAlertController (title: "Error",  message: message, preferredStyle: .alert)
           alertViewController.addAction(UIAlertAction(title: "Error", style: .default, handler: {(action: UIAlertAction) in
           }))
           self.present(alertViewController, animated: true, completion: nil)
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
