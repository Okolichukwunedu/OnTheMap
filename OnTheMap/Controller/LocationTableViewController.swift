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
    
    @IBOutlet var tableList: UITableView!
    @IBOutlet weak var imageView: UIImage!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableList.delegate = self
        tableList.dataSource = self
        tableView.reloadData()
        self.clearsSelectionOnViewWillAppear = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        OTMUser.getStudentMapPoints {students, error in
            StudentDataInfo.sharedInstance().students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData ()
            }
        }
    }
    
    func showLogoutFailure(message: String) {
        let alertViewController = UIAlertController (title: "Error",  message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertViewController, animated: true)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        LogOutRequest.logout(completion: self.handleLogoutRequest(success: error:))
    }
    
    func handleLogoutRequest(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            showLogoutFailure(message: "Loggin out failed. Try again!")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentDataInfo.sharedInstance().students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = StudentDataInfo.sharedInstance().students[(indexPath as NSIndexPath).row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = "\(String(list.firstName))" + " " + "\(String(list.lastName))"
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = StudentDataInfo.sharedInstance().students[(indexPath as NSIndexPath).row]
        let url = URL(string: list.mediaURL ?? " ")!
    }
}
