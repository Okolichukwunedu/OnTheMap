//
//  UdacityResponse.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 27/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    let account: Account
    let session: Session
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct Account: Codable {
    let registered: Bool
    let key: String
}
