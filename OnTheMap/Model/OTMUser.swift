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
                return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
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

    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            let newData = data.subdata(in: 5..<data.count)
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
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
        return task
    }
    
    class func getUserInformation(completion: @escaping (OTMUserResponse?, Error?) -> Void) {
        let url = Endpoints.getUserInformation.url
        taskForGETRequest(url: url, responseType: OTMUserResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
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
