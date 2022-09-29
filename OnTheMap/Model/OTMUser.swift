//
//  OTMUser.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 21/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit

class OTMUser {
    
    struct Auth {
        static var sessionId = ""
        static var uniqueKey = ""
        static var accountKey = ""
        static var firstName = ""
        static var lastName = ""
        static var mediaURL = ""
        static var token = ""
        static var mapString = ""
        static var objectId = ""
        static var longitude: Double = 0.0
        static var latitude: Double = 0.0
        static var createdAt = ""
        static var updatedAt = ""
    }
    
    enum Endpoints {
    
        case login
        case logout
        case getUserInformation
        case getMapPoints
        case postStudentLocation
        case getUniqueStudentLocation
        
        
        var stringValue: String {
            switch self {
            case .login:
                return "https://onthemap-api.udacity.com/v1/session"
            case .logout:
                return "https://onthemap-api.udacity.com/v1/session"
            case .getUserInformation:
                return "https://onthemap-api.udacity.com/v1/users/\(Auth.accountKey)"
            case .getMapPoints:
                return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updateAt"
            case .postStudentLocation:
                return "https://onthemap-api.udacity.com/v1/StudentLocation"
 
            case .getUniqueStudentLocation:
                return "https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey="
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }

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
                    self.Auth.sessionId = responseObject.session.id
                    self.Auth.accountKey = responseObject.account.key
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

    class func logout(completion: @escaping () -> Void) {

        var request = URLRequest(url: OTMUser.Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { //Handle error...
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            completion()
        }
        task.resume()
    }

    
    class func getUserInformation(completion: @escaping (OTMUserResponse?, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getUserInformation.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            let newData = data.subdata(in: 5..<data.count)
            do {
                let responseObject = try decoder.decode(OTMUserResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }


    
    class func getStudentMapPoints (completion: @escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getMapPoints.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let responseObject = try decoder.decode(StudentInformationResponse.self, from: data)
                    DispatchQueue.main.async {
                        studentInformationModel.locationResults = responseObject.user
                        completion(true, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
            task.resume()
    }
    
    
    class func postStudentLocation (postRequest: PostStudentLocation, completion: @escaping (StudentLocation?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = postRequest
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(StudentLocation.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                 }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                 }
             }
         }
         task.resume()
    }
 }
