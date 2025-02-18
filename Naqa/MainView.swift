//
//  MainView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import SwiftUI

struct MainView: View {
    @State private var selection: AppScreen? = .calculator
    
    var body: some View {
        AppTabView(selection: $selection)
    }
    
}

#Preview {
    MainView()
}
