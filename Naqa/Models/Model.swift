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
    @Published var selectedStock: Stock?
    @Published var stocksCount: String = ""
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    
    @Published var isLoading: Bool = false
    
    let stockService: StockService
    
    init(stockService: StockService) {
        self.stockService = stockService
        Task{ await fetchOnAppear() }
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
    
    func calculatePurificationForYear() async throws {
        let year = Calendar.current.dateComponents([.year], from: startDate).year
        guard let code = selectedStock?.code, let stocksCountInt = Int(stocksCount) else {
            return
        }
        
        do {
            isLoading = true
            self.response = try await stockService.calculatePurification(year: year!.description, request: .init(startDate: startDate, endDate: endDate, numberOfStocks: stocksCountInt, stockCode: code))
            isLoading = false
        } catch {
            isLoading = false
            print("Error: \(error)")
        }

    }
    
}
