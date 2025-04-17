//
//  String+Ext.swift
//  Naqa
//
//  Created by Lulwah almisfer on 22/02/2025.
//

import Foundation

extension String {

    func firstDayOfYear() -> Date {
        let calendar = Calendar.current
        let static2019 = calendar.date(from: DateComponents(year: 2019, month: 1, day: 1))!

        guard let year = Int(self) else { return static2019 }
        
        return calendar.date(from: DateComponents(year: year, month: 1, day: 1)) ?? static2019
    }
    
    func lastDayOfYear() -> Date {
        let calendar = Calendar.current
        let static2019 = calendar.date(from: DateComponents(year: 2019, month: 12, day: 31))!

        guard let year = Int(self) else { return static2019 }
        
        return calendar.date(from: DateComponents(year: year, month: 12, day: 31)) ?? static2019
    }
    
}

extension Date {
    func addOneDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
}
