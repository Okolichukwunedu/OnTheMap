//
//  UdacityResponse.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 27/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
