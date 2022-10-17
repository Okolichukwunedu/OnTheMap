//
//  OTMUserResponse.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 28/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation

struct OTMUserResponse: Codable {
    let firstName: String
    let lastName: String
    let accountKey: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case accountKey = "key"
    }
}
