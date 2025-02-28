//
//  SettingsView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 28/02/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Button("Change Language") {
                    Helper.goToAppSetting()
                }
                Text("todo about almaqased")
                Text("todo team")
                Text("todo ehsan link")
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
