//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 21/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit

class LocationTableViewController: UITableViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var addLocation: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        self.clearsSelectionOnViewWillAppear = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.tableView.reloadData ()
    }
    
    func showErrorDisplay (title: String, message: String) {
        let alertViewController = UIAlertController (title: title,  message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertViewController, animated: true)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        performSegue(withIdentifier: "addLocation", sender: sender)
    }
    
    @IBAction func logout(_ sender: Any) {
        LogoutRequest.logout() {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformationModel.locationResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = studentInformationModel.locationResults[(indexPath as NSIndexPath).row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = list.firstName + " " + list.lastName
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = studentInformationModel.locationResults[(indexPath as NSIndexPath).row]
        if let url = URL(string: list.mediaURL) {
            UIApplication.shared.open(url)
        } else {
            showErrorDisplay(title: "Error!", message: "Unable to open the URL")
        }
    }
}
