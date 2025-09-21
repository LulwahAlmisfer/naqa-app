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
    @State private var showingInfo = false

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
                            AsyncCompanyLogoView(ticker: stock.code, urlString:stock.logo)
                        } else {
                            Circle()
                                .foregroundStyle(.white)
                                .frame(width: 33, height: 33)
                        }
                        VStack(alignment: .leading){
                            Text(Helper.isCurrentLanguageArabic() ? stock.name_ar : stock.name_en)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                .font(.system(size: Helper.isCurrentLanguageArabic() ? 17 : 12))
                            Text(stock.code)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        if let purification = stock.purification, !purification.isEmpty {
                            Text("%\(purification)")
                                .font(.caption)
                        }
                        
                        Text(LocalizedStringKey(stock.shariaOpinion.title))
                            .lineLimit(1)
                            .font(.system(size: Helper.isCurrentLanguageArabic() ? 18 : 13))
                            .foregroundStyle(stock.shariaOpinion.color)
                            .padding(6)
                            .background(stock.shariaOpinion.color.opacity(0.2))
                            .clipShape(.capsule)
                    }
                }
            }
            .logEvent("StockListView_Opended")
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
        HStack {
            Menu {
                ForEach(model.years.reversed(), id: \.self) { year in
                    Button(action: { model.screen1SelectedYear = year }) {
                        HStack {
                            Text(year)
                            if model.screen1SelectedYear == year {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(model.screen1SelectedYear)
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(.naqaLightPurple)
                }
                .padding(8)
            }
            
            Spacer()

            Button {
                showingInfo = true
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.naqaLightPurple)
            }
            .sheet(isPresented: $showingInfo) {
                Form {
                    Text(.init("TITLE"))
                        .font(.headline)
                    Text(.init("DESC"))
                        .font(.body)

                    Section {
                        Text(.init("موقع المقاصد"))
                     }
                }
                .ignoresSafeArea(.all)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }

        }
    }


}


#Preview {
    StocksListView()
        .environmentObject(Model(stockService: StockService()))
}
