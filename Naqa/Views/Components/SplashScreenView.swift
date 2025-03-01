//
//  SplashScreenView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 01/03/2025.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        Group {
            if isActive {
                MainView()
            } else {
                Image(.launch)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
        }
    }
}
