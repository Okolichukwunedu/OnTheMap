//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 27/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    
    let key: String?
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
    }
}

struct Session: Codable {
    let sessionId: String?
    let expiration: String?
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "id"
        case expiration = "expiration"
    }
}
