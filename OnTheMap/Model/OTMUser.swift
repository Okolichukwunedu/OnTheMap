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
        static var sessionID: String? = nil
        static var uniqueKey = " "
        static var firstName = " "
        static var lastName = " "
        static var mediaURL = " "
        static var token = " "
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
    
        case login
        case logout
        case getUserInformation
        case getMapPoints
        case postStudentLocation
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "session"
            case .logout:
                return Endpoints.base + "session"
            case .getUserInformation:
                return Endpoints.base + "/users/" + Auth.uniqueKey
            case .getMapPoints:
                return Endpoints.base + "/v1/StudentLocation?limit=100&order=-updateAt"
            case .postStudentLocation:
                return Endpoints.base + "StudentLocation"
 
            }
        }
    }
    

    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            let decoder = JSONDecoder ()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
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
        }
        task.resume()
            return task
    }
     
    class func getUserInformation(completion: @escaping (Bool, Error?) -> Void) { taskForGETRequest (url: Endpoints.self.getUserInformation.url, responseType: StudentInformation.self) { (response, error) in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentMapPoints (completion: @escaping ([DataInfo]?, Error?) -> Void) {
        taskForGETRequest (url: Endpoints.self.getMapPoints.url, responseType: StudentLocation.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func taskPOSTRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: String, httpMethod: String, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = body.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { //Handle error...
                    completion(nil,error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
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
    
    
    class func addLocation(information: DataInfo, completion: @escaping (Bool, Error?) -> Void) {
        let json = "{\"uniqueKey\": \"\(information.uniqueKey )\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\", \"mapString\": \"\(information.mapString )\", \"mediaURL\": \"\(information.mediaURL )\", \"latitude\": \(information.latitude ), \"longitude\": \(information.longitude )}"
        
        taskPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostLocation.self, body: json, httpMethod: "POST") { (response, error) in
            if let response = response, response.createdAt != nil {
                Auth.token = response.objectId ?? " "
                completion(true, nil)
            }
            completion(false, error)
            }
    }

}
