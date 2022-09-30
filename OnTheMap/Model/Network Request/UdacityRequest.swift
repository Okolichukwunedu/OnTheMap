//
//  UdacityRequest.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 28/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation

struct UdacityRequest: Codable {
    let udacity: Udacity
}

struct Udacity: Codable {
    let username: String
    let password: String
}
