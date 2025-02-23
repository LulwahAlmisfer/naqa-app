//
//  StocksListView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import SwiftUI

struct StocksListView: View {
    @EnvironmentObject private var model: Model
    @State private var selectedMarket: Market = .main

    enum Market: String, CaseIterable {
        case main = "السوق الرئيسي"
        case nomu = "نمو"
    }

    var filteredStocks: [Stock] {
        model.screen1FilteredStocks.filter { stock in
            selectedMarket == .main ? stock.code <= "9000" : stock.code > "9000"
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                
                
                picker
                
                List(filteredStocks) { stock in
                    HStack {
                        Image(stock.code)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(.circle)
                        
                        Text(stock.name)
                        
                        Text(stock.code)
                            .font(.caption)
                        
                        Spacer()
                        
                        if let purification = stock.purification {
                            Text(purification)
                                .font(.caption)
                        }
                        
                        Text(stock.shariaOpinion.title)
                            .foregroundStyle(stock.shariaOpinion.color)
                            .padding(8)
                            .background(stock.shariaOpinion.color.opacity(0.2))
                            .clipShape(.capsule)
                    }
                }
            }
            .navigationTitle("القوائم")
           // .navigationBarTitleDisplayMode(.)
            .searchable(text: $model.screen1SearchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    marketSegmentedControl
                        .frame(width: 200)
                }
            }
        }
        .ignoresSafeArea()
        .onChange(of: model.screen1SelectedYear) { _, _ in
            Task { await model.getStocksForScreen1SelectedYear() }
        }
    }

    var marketSegmentedControl: some View {
        Picker("السوق", selection: $selectedMarket) {
            ForEach(Market.allCases, id: \.self) { market in
                Text(market.rawValue).tag(market)
            }
        }
        .pickerStyle(.segmented)
        .padding(.vertical, 8)
    }

    var picker: some View {
        Picker("اختر السنة", selection: $model.screen1SelectedYear) {
            ForEach(model.years, id: \.self) { year in
                Text(year).tag(year)
            }
        }
    }
}


#Preview {
    StocksListView()
        .environmentObject(Model(stockService: StockService()))
}
