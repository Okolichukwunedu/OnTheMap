//
//  newStudentLocation.swift
//  OnTheMap
//
//  Created by Okoli-Chinedu on 24/09/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation

struct newStudentLocation: Codable {
    var firstName: String?
    var lastName: String?
    var mediaURL: String?
    var uniqueKey: String?
    var objectId: String?
    var mapString: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
}
