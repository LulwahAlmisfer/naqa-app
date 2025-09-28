//
//  CloudKitPushNotifciationViewModel.swift
//  Naqa
//
//  Created by Lulwah almisfer on 28/09/2025.
//

import CloudKit
import SwiftUI

class CloudKitPushNotifciationViewModel: ObservableObject {
    
    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
            } else if success {
                print("Notification permissions success!")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permissions failure.")
            }
        }
        subscribeToNotifications()
    }
    
    func subscribeToNotifications() {
        
        let predicate = NSPredicate(value: true)

        let subscription = CKQuerySubscription(recordType: "announcement", predicate: predicate, subscriptionID: "announcement_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()

        if Helper.isCurrentLanguageArabic() {
            notification.title = "قائمة المقاصد الجديدة متوفرة الآن"
            notification.alertBody = "افتح التطبيق للاطلاع على القائمة."
        } else {
            notification.title = "New Maqasid list is now available"
            notification.alertBody = "Open the app to check the new list."
        }
        notification.soundName = "default"

        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully subscribed to notifications!")
            }
        }
    }

}


