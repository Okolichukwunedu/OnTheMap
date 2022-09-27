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
        static var sessionID = " "
        static var uniqueKey = " "
        static var firstName = " "
        static var lastName = " "
        static var mediaURL = " "
        static var token = " "
        static var mapString = " "
        static var objectId = " "
        static var longitude: Double = 0
        static var latitude: Double = 0
        static var createdAt = " "
        static var updatedAt = " "
    }
    
    enum Endpoints {
    
        case login
        case logout
        case getUserInformation
        case getMapPoints
        case postStudentLocation
        case getUniqueStudentLocation
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .login:
                return "https://onthemap-api.udacity.com/v1/session"
            case .logout:
                return "https://onthemap-api.udacity.com/v1/session"
            case .getUserInformation:
                return "https://onthemap-api.udacity.com/v1/users/\(Auth.uniqueKey)"
            case .getMapPoints:
                return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updateAt"
            case .postStudentLocation:
                return "https://onthemap-api.udacity.com/v1/StudentLocation"
 
            case .getUniqueStudentLocation:
                return "https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey="
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
     
    class func getUserInformation(completion: @escaping (StudentInformation?, Error?) -> Void) { taskForUdacityGETRequest (url: Endpoints.self.getUserInformation.url, responseType: StudentInformation.self) { (response, error) in
            if let response = response {
                Auth.firstName = response.firstName!
                Auth.lastName = response.lastName!
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    class func taskForUdacityGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
           
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            let newData = data?.subdata(in: 5..<data!.count)
            print(String(data: newData!, encoding: .utf8))
        
            let decoder = JSONDecoder ()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let responseObject = try decoder.decode(UdacityResponse.self, from: newData!) as! Error
                    DispatchQueue.main.async {
                        completion(nil, responseObject)
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
        
    
    class func getStudentMapPoints (completion: @escaping ([DataInfo]?, Error?) -> Void) {
        taskForGETRequest (url: Endpoints.self.getMapPoints.url, responseType: StudentLocation.self) { (response, error) in
            if let response = response {
                completion(response.studentInfo, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = try! JSONEncoder().encode(body)
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
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            
                do {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
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
    
    
    class func addLocation(completion: @escaping (newStudentLocation?, Error?) -> Void) {
        var request = URLRequest(url:  Endpoints.self.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = "{\"uniqueKey\": \"\(Auth.uniqueKey )\", \"firstName\": \"\(Auth.firstName)\", \"lastName\": \"\(Auth.lastName)\", \"mapString\": \"\(Auth.mapString )\", \"mediaURL\": \"\(Auth.mediaURL )\", \"latitude\": \(Auth.latitude ), \"longitude\": \(Auth.longitude )}"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil {
                return
            }
            
            print(String(data: data!, encoding: .utf8)!)
        let decoder = JSONDecoder ()
                do {
                    let responseObject = try decoder.decode(newStudentLocation.self, from: data!)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } catch {
                    do {
                        let responseObject = try decoder.decode(UdacityResponse.self, from: data!) as! Error
                        DispatchQueue.main.async {
                            completion(nil, responseObject)
                            }
                        } catch {
                            DispatchQueue.main.async {
                                completion(nil, error)
                        }
                    }
                }
            }
            task.resume()
        }
    
    class func getUniqueStudentNames(completion: @escaping ([DataInfo], Error?) -> Void) {
        taskForGETRequest (url: Endpoints.self.getMapPoints.url, responseType: StudentLocation.self) { (response, error) in
            if let response = response {
                completion(response.studentInfo, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func putStudentLocation (completion: @escaping (PostLocation?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation/\(Auth.objectId)")!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = "{\"uniqueKey\": \"\(Auth.uniqueKey )\", \"firstName\": \"\(Auth.firstName)\", \"lastName\": \"\(Auth.lastName)\", \"mapString\": \"\(Auth.mapString )\", \"mediaURL\": \"\(Auth.mediaURL )\", \"latitude\": \(Auth.latitude ), \"longitude\": \(Auth.longitude )}"
    
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil {
                return
            }
        
            print(String(data: data!, encoding: .utf8)!)
        let decoder = JSONDecoder ()
            do {
                let responseObject = try decoder.decode(PostLocation.self, from: data!)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                        Auth.updatedAt = responseObject.updatedAt!
                }
            } catch {
                do {
                    let responseObject = try decoder.decode(UdacityResponse.self, from: data!) as! Error
                    DispatchQueue.main.async {
                        completion(nil, responseObject)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }

}
