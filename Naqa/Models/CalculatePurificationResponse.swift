//
//  CalculatePurificationResponse.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import Foundation

struct CalculatePurificationResponse: Codable {
    let id: String
    let purificationAmount: Double
    let daysHeld: Int
    let purificationRate: Double

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case purificationAmount = "purification_amount"
        case daysHeld = "days_held"
        case purificationRate = "purification_rate"
    }
}
