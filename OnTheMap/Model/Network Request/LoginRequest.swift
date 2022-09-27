//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 21/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit

class LoginRequest {

    class func login (username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: OTMUser.Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //Encoding a JSON body from a string, can also use a Codable struct
        let json = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        request.httpBody = json.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { //Handle error...
                completion(false, error?.localizedDescription as! Error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
    }
}
