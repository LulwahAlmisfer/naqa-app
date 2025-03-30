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
            List(model.stocks) { stock in
                HStack {
                    Image(stock.code)
                        .resizable()
                        .frame(width: 30,height: 30)
                        .clipShape(.circle)
                    Text(stock.name)
                }
            }
            .navigationTitle("القوائم")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: .constant(""))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    StocksListView()
        .environmentObject(Model(stockService: StockService()))
}
