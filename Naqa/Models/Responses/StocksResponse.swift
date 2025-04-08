//
//  StocksResponse.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import SwiftUI

struct StockData: Codable {
    let stocks: [Stock]
}
struct Stock: Codable,Identifiable {
    let id, name, code, sector: String
    let shariaOpinion: ShariaOpinion
    let purification: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, code, sector
        case shariaOpinion = "sharia_opinion"
        case purification
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        code = try container.decode(String.self, forKey: .code)
        sector = try container.decode(String.self, forKey: .sector)
        purification = try container.decode(String.self, forKey: .purification)
        shariaOpinion = (try? container.decode(ShariaOpinion.self, forKey: .shariaOpinion)) ?? .none
    }
    
}


enum ShariaOpinion: String, CaseIterable,Codable {
    case pure = "نقية"
    case mixed = "مختلطة"
    case nonCompliant = "غير متوافقة"
    case none
    
    var description: String {
        switch self {
        case .pure:
            return "أسهم متوافقة تماماً مع الشريعة"
        case .mixed:
            return "أسهم تحتاج إلى تطهير"
        case .nonCompliant:
            return "أسهم غير متوافقة مع الشريعة"
        case .none:
            return ""
        }
    }
    
    var order: Int {
        switch self {
        case .pure:
            1
        case .mixed:
            2
        case .nonCompliant:
            3
        case .none:
            4
        }
    }
    
    var color: Color {
        switch self {
        case .pure:
            return .green
        case .mixed:
            return .yellow
        case .nonCompliant:
            return .red
        case .none:
            return .gray
        }
    }
}
