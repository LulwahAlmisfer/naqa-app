//
//  String+Ext.swift
//  Naqa
//
//  Created by Lulwah almisfer on 22/02/2025.
//

import SwiftUI
import PostHog

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

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resolveInstanceMethod), to: nil, from: nil, for: nil)
}

struct Helper {
    static func goToAppSetting() {
        DispatchQueue.main.async {
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
}

extension Double {
    func rounded(to places: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = places
        formatter.maximumFractionDigits = places
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

extension View {
    func logEvent(_ event: String) -> some View {
        self.onAppear {
            PostHogSDK.shared.capture(event)
        }
    }
}

func identifyUser() {
    let userDefaults = UserDefaults.standard
    let userIdKey = "posthog_user_id"

    if let storedUserId = userDefaults.string(forKey: userIdKey) {
        print("🔍 Using existing User ID: \(storedUserId)")
        PostHogSDK.shared.identify(storedUserId)
    } else {

        let newUserId = UUID().uuidString
        userDefaults.set(newUserId, forKey: userIdKey)
        print("🆕 Generated new User ID: \(newUserId)")
        PostHogSDK.shared.identify(newUserId)
    }
}

extension Array where Element == Stock {
    func sortedBySharia() -> [Stock] {
        self.sorted {
            if $0.shariaOpinion.order == $1.shariaOpinion.order {
                return $0.code < $1.code // Secondary sorting by stock.code
            }
            return $0.shariaOpinion.order < $1.shariaOpinion.order // Primary sorting by shariaOpinion.order
        }
    }
}
