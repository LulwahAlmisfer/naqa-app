//
//  CalculatePurificationResponse.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import Foundation

struct YearlyBreakdown: Codable, Identifiable {
    let id = UUID() 
    let year: Int
    let purificationRate: Double
    let daysInPeriod: Int
    let totalDaysInYear: Int
    let yearProportion: Double
    let purificationAmount: Double
    let companyNameEn: String
    let companyNameAr: String
    let shariaOpinion: String

    private enum CodingKeys: String, CodingKey {
        case year
        case purificationRate = "purification_rate"
        case daysInPeriod = "days_in_period"
        case totalDaysInYear = "total_days_in_year"
        case yearProportion = "year_proportion"
        case purificationAmount = "purification_amount"
        case companyNameEn = "company_name_en"
        case companyNameAr = "company_name_ar"
        case shariaOpinion = "sharia_opinion"
    }
}

struct CalculatePurificationResponse: Codable {
    let id: String
    let purificationAmount: Double
    let daysHeld: Int
    let purificationRate: Double
    let yearlyBreakdown: [YearlyBreakdown]?
    let isMultiYear: Bool?
    let warnings: [String]?

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case purificationAmount = "purification_amount"
        case daysHeld = "days_held"
        case purificationRate = "purification_rate"
        case yearlyBreakdown = "yearly_breakdown"
        case isMultiYear = "is_multi_year"
        case warnings
    }
}
