//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 21/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let firstName: String?
    let lastName: String?
    let key: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key = "key"
    }
}

struct PublicUserInfoDetails: Codable {
    let user: [StudentInformation]?
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
    }
}

class StudentDataInfo: NSObject {
    
    var students = [DataInfo]()
    
    class func sharedInstance() -> StudentDataInfo {
        struct Singleton {
            static var sharedInstance = StudentDataInfo ()
        }
        return Singleton.sharedInstance
    }
}