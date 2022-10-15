//
//  StudentInformationResponse.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 28/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation

struct StudentInformationResponse: Codable {
    let user: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case user = "results"
    }
}

struct StudentInformation: Codable {
    var firstName: String
    var lastName: String
    var mediaURL: String
    var uniqueKey: String
    var objectId: String
    var mapString: String
    var latitude: Double
    var longitude: Double
    var createdAt: String
    var updatedAt: String
}
