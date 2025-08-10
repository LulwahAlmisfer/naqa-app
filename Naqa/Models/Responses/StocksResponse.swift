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
    let id, name_ar, name_en, code, sector: String
    let shariaOpinion: ShariaOpinion
    let purification: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name_ar, name_en , code, sector
        case shariaOpinion = "sharia_opinion"
        case purification
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name_ar = try container.decode(String.self, forKey: .name_ar)
        name_en = try container.decode(String.self, forKey: .name_en)
        code = try container.decode(String.self, forKey: .code)
        sector = try container.decode(String.self, forKey: .sector)
        
        if let purification = try? container.decodeIfPresent(String.self, forKey: .purification), purification != "NaN" {
            self.purification = purification
        } else {
            self.purification = nil
        }
        
        shariaOpinion = (try? container.decode(ShariaOpinion.self, forKey: .shariaOpinion)) ?? .none
    }
    
}


enum ShariaOpinion: String, CaseIterable,Codable {
    case pure = "نقية"
    case mixed = "مختلطة"
    case nonCompliant = "غير متوافقة"
    case Prohibited = "غير متوافقة النشاط"
    case none
    
    
    var title: String {
        switch self {
        case .pure:
            return "نقية"
        case .mixed:
            return "مختلطة"
        case .nonCompliant:
            return "غير متوافقة"
        case .Prohibited:
            return "محرمة النشاط"
        case .none:
            return "لا يوجد"
        }
    }
    var description: String {
        switch self {
        case .pure:
            return "أسهم متوافقة تماماً مع الشريعة"
        case .mixed:
            return "أسهم تحتاج إلى تطهير"
        case .nonCompliant:
            return "أسهم غير متوافقة مع الشريعة"
        case .Prohibited:
            return "هي ما كان أصل نشاطها محرما، حتى لو تمولت أو استثمرت في مباح، مثل البنوك التجارية التقليدية"
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
        case .Prohibited:
            4
        case .none:
            5
        }
    }
    
    var color: Color {
        switch self {
        case .pure:
            return .green
        case .mixed:
            return .yellow
        case .nonCompliant:
            return .orange
        case .Prohibited:
            return .red
        case .none:
            return .gray
        }
    }
}
