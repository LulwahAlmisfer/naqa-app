//
//  Model.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import Foundation

enum OrderError: Error {
    case custom(String)
}

@MainActor
class Model: ObservableObject {
    @Published var selectedYear: String?
    @Published var years: [String] = []
    @Published var stocks: [Stock] = []
    @Published var response: CalculatePurificationResponse? = nil
    
    let stockService: StockService
    
    init(stockService: StockService) {
        self.stockService = stockService
        Task{ await fetchOnAppear() }
        Task{
          try await calculatePurificationForYear(startDate: Date.now, endDate: Date.now.addingTimeInterval(-86400), count: 20, code: "2222")
        }
    }
    
    func fetchOnAppear() async {
        do {
            try await getAvailableYears()
            try await getStocksForSelectedYear()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func getAvailableYears() async throws {
        self.years = try await stockService.getAvailableYears()
        selectedYear = years.last
    }
    
    func getStocksForSelectedYear() async throws {
        // TODO: cache layer
        
        guard let selectedYear = self.selectedYear else {
            return
        }
        
        self.stocks = try await stockService.getStocksByYear(year: selectedYear)
    }
    
    func calculatePurificationForYear(startDate:Date, endDate:Date ,count:Int, code:String) async throws {
        let year = Calendar.current.dateComponents([.year], from: startDate).year
        do {
            self.response = try await stockService.calculatePurification(year: year!.description, request: .init(startDate: startDate, endDate: endDate, numberOfStocks: count, stockCode: code))
        } catch {
            print("Error: \(error)")
        }

    }
    
}
