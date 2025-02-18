//
//  YearsResponse.swift.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import Foundation

struct Year: Codable {
    let availableYears: [String]
    let message, status: String

    enum CodingKeys: String, CodingKey {
        case availableYears = "available_years"
        case message, status
    }
}
