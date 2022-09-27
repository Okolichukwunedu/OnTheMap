//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 21/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let studentInfo: [DataInfo]
    
    enum CodingKeys: String, CodingKey {
        case studentInfo = "results"
    }
}

struct DataInfo: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mediaURL: String
    var objectId: String
    var mapString: String
    var latitude: Double
    var longitude: Double
    var createdAt: String?
    var updatedAt: String?
}


struct PostLocation: Codable{
    let createdAt: String?
    let objectId: String?
    let statusCode: Int?
    let updatedAt: String?
}
