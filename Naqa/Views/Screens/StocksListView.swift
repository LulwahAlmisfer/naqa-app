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
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var showSheet = false

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
                
                ForEach(model.viewState == .done ? filteredStocks : model.dummyStocks) { stock in
                    HStack {
                        
                        if model.viewState == .done {
                            AsyncCompanyLogoView(ticker: stock.code)
                        } else {
                            Circle()
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        
                        Text(stock.name)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)

                        
                        Spacer()
                        
                        if let purification = stock.purification {
                            Text("%\(purification)")
                                .font(.callout)
                        }
                        
                        Text(LocalizedStringKey(stock.shariaOpinion.title))
                            .lineLimit(1)
                            .foregroundStyle(stock.shariaOpinion.color)
                            .padding(8)
                            .background(stock.shariaOpinion.color.opacity(0.2))
                            .clipShape(.capsule)
                    }
                }
            }
            .disabled(model.viewState == .loading)
            .shimmer(model.viewState)
            .navigationTitle("القوائم")
            .searchable(text: $model.screen1SearchText,
                        placement: .navigationBarDrawer(displayMode: .always)
                        ,prompt:"إبحث بالاسم أو الرمز")
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
                Text(LocalizedStringKey(market.rawValue)).tag(market)
            }
        }
        .pickerStyle(.segmented)
        .padding(.vertical, 8)
    }

    var picker: some View {
        Button(action: { showSheet.toggle() }) {
            HStack {
                  Text(model.screen1SelectedYear)
                      .foregroundColor(.primary)
                Image(systemName: "chevron.down")
                    .foregroundColor(.naqaLightPurple)
                Spacer()
            }
            .padding(8)
        }
        .sheet(isPresented: $showSheet) {
            NavigationView {
                List(model.years.reversed(), id: \.self) { year in
                    Button(action: {
                        model.screen1SelectedYear = year
                        showSheet = false
                    }) {
                        HStack {
                            Text(year)
                            Spacer()
                            if model.screen1SelectedYear == year {
                                Image(systemName: "checkmark")
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .navigationTitle("اختر السنة")
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
}


#Preview {
    StocksListView()
        .environmentObject(Model(stockService: StockService()))
}
