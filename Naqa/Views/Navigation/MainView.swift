//
//  MainView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedScreen: AppScreen? = .stocks
    private var service = StockService()

    var body: some View {
        AppTabView(selection: $selectedScreen)
            .environment(Router())
            .environmentObject(Model(stockService: service))
            .environment(\.layoutDirection, .rightToLeft) // better to find another solution
    }
    
}
