//
//  Stock.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import SwiftUI

struct Stock: Codable,Identifiable {
    let id, name, code, sector: String
    let shariaOpinion: ShariaOpinion
    let purification: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, code, sector
        case shariaOpinion
        case purification
    }
}


enum ShariaOpinion: String, CaseIterable,Codable {
    case pure = "نقية"
    case mixed = "مختلطة"
    case nonCompliant = "غير متوافقة"
    case nan
    
    var description: String {
        switch self {
        case .pure:
            return "أسهم متوافقة تماماً مع الشريعة | Fully Shariah Compliant Stocks"
        case .mixed:
            return "أسهم تحتاج إلى تطهير | Stocks Requiring Purification"
        case .nonCompliant:
            return "أسهم غير متوافقة مع الشريعة | Non-Shariah Compliant Stocks"
        case .nan:
            return ""
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
        case .nan:
            return .clear
        }
    }
}
