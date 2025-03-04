//
//  NaqaApp.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import SwiftUI
import PostHog

@main
struct NaqaApp: App {
    @State private var isActive = false
    
    init() {
        
        let POSTHOG_API_KEY = "phc_aiFfHEN4bLh8vqAP23OHEAPDzK7wMRoiI0szRVuXg5O"
        let POSTHOG_HOST = "https://us.i.posthog.com"

        let config = PostHogConfig(apiKey: POSTHOG_API_KEY, host: POSTHOG_HOST)
        PostHogSDK.shared.setup(config)
        identifyUser()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .logEvent("App_Launched")
        }
    }
}
