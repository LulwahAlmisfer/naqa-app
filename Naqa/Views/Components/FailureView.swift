//
//  FailureView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 27/09/2025.
//

import SwiftUI

struct FailureView: View {
    public var iconName: String = "wifi.slash"
    public let message: String
    public let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 50))
                .foregroundColor(.red)

            Text(.init(message))
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: retryAction) {
                Label(LocalizedStringKey("Retry"), systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
            .tint(.accent)
        }
        .padding()
    }
}
