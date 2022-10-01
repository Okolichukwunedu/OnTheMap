//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 30/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit

class LoginRequest {
    
    class func login (username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let UdacityDetail = Udacity(username: username, password: password)
        let body = UdacityRequest(udacity: UdacityDetail)
        var request = URLRequest(url: OTMUser.Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
            
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
                
            //Skip the first 5 characters of the response
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
                
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UdacityResponse.self, from: newData)
                DispatchQueue.main.async {
                    OTMUser.Auth.sessionId = responseObject.session.id
                    OTMUser.Auth.accountKey = responseObject.account.key
                    completion(true, nil)
                }
            }catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
}
