//
//  TabViews.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import SwiftUI
enum AppScreen: Hashable, Identifiable, CaseIterable {
    
    case calculator
    case stocks
    
    var id: AppScreen { self }
}

extension AppScreen {
    
    @ViewBuilder
    var label: some View {
        switch self {
        case .calculator:
            Label("الحاسبة", systemImage: "percent")
        case .stocks:
            Label("القوائم", systemImage: "chart.bar.xaxis")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .calculator:
            Text("الحاسبة")
        case .stocks:
            Text("القوائم")
        }
    }
    
}

struct AppTabView: View {
    
    @Binding var selection: AppScreen? 
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .tabItem { screen.label }
            }
        }
    }
}

@Observable
class Router {
    var calculatorRoutes: [CalculatorRoute] = []
}

enum CalculatorRoute: Hashable {
    case main
    case search
}

struct CalculatorNavigationStack: View {
    
    @Environment(Router.self) private var router
    
    var body: some View {
        
        @Bindable var router = router
        
        NavigationStack(path: $router.calculatorRoutes) {
            Button("Plants Go to detail") {
                router.calculatorRoutes.append(.search)
            }.navigationDestination(for: CalculatorRoute.self) { route in
                switch route {
                case .main:
                        Text("main")
                case .search:
                        Text("search")
                }
            }
        }
    }
}
