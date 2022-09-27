//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 21/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK: Declare variables
    let textFieldsDelegate = TextFieldsDelegate()
    
    let fieldTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0]
    
    func prepareTextField (textField: UITextField, defaultText: String) {
        textField.defaultTextAttributes = fieldTextAttributes
        textField.textAlignment = .left
        self.emailTextField.delegate = textFieldsDelegate
        self.passwordTextField.delegate = textFieldsDelegate
    }
    
    //MARK: define the views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTextField(textField: emailTextField, defaultText: "Enter your e-mail")
        prepareTextField(textField: passwordTextField, defaultText: "Enter your password")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: Subscribe to Keyboard Notifications
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //MARK: Unsubscribe to Keyboard Notifications
        unsubscribeToKeyboardNotifications()
    }
    

    @IBAction func loginPressed(_ sender: AnyObject) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.showLoginFailure(message: "Username or Password is Empty.")
        }
        setLoggingIn(true)
        LoginRequest.login(username: self.emailTextField.text!, password: self.passwordTextField.text!) { (success, error) in
            if success {
                self.UserInformation()
            } else {
                self.showLoginFailure(message: error as! String ?? " ")
                }
        }
    }
    
    func showLoginFailure(message: String) {
        let alertViewController = UIAlertController (title: "Login Failed",  message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertViewController, animated: true)
    }
    
    func UserInformation() {
        OTMUser.getUserInformation(completion: { (success, error) in
            if (success != nil) {
                print ("success")
            } else {
                print ("Failed!")
            }
            
        })
    }
    
    func setLoggingIn(_ logginIn: Bool ) {
        if logginIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !logginIn
        passwordTextField.isEnabled = !logginIn
        loginButton.isEnabled = !logginIn
    }
    
}

extension LoginViewController {
    
    //MARK: Functions for the Keyboard Notifications
       @objc func keyboardWillShow(_ notification: Notification) {
           if passwordTextField.isEditing {
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
