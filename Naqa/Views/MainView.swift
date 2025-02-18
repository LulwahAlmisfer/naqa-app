//
//  MainView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedScreen: AppScreen? = .stocks
    
    var body: some View {
        AppTabView(selection: $selectedScreen)
            .environment(Router())
    }
    
}

#Preview {
    MainView()
}
