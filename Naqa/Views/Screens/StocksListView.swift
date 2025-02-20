//
//  StocksListView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import SwiftUI

struct StocksListView: View {
    @EnvironmentObject private var model: Model

    var body: some View {
        NavigationStack{
            VStack{
                picker
                
                List(model.screen1FilteredStocks) { stock in
                    HStack {
                        Image(stock.code)
                            .resizable()
                            .frame(width: 30,height: 30)
                            .clipShape(.circle)
                        Text(stock.name)
                        
                        Text(stock.shariaOpinion.rawValue)
                            .foregroundStyle(stock.shariaOpinion.color)
                    }
                }
                
            }
            .navigationTitle("القوائم")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $model.screen1SearchText ,placement:.navigationBarDrawer(displayMode: .always))
        }
        .ignoresSafeArea()
        .onChange(of: model.screen1SelectedYear) { _ , _ in
            Task{ await model.getStocksForScreen1SelectedYear() }
        }
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
