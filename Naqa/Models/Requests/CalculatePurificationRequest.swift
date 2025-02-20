//
//  CalculatePurificationRequest.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import Foundation

struct CalculatePurificationRequest: Codable {
    let startDate: Date
    let endDate: Date
    let numberOfStocks: Int
    let stockCode: String

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX") 

        try container.encode(formatter.string(from: startDate), forKey: .startDate)
        try container.encode(formatter.string(from: endDate), forKey: .endDate)
        try container.encode(numberOfStocks, forKey: .numberOfStocks)
        try container.encode(stockCode, forKey: .stockCode)
    }

    private enum CodingKeys: String, CodingKey {
        case endDate = "end_date"
        case numberOfStocks = "number_of_stocks"
        case startDate = "start_date"
        case stockCode = "stock_code"
    }
}
