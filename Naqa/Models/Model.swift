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
    
    @Published var isLoadingAnswer: Bool = false
    @Published var error: NaqaErrorResponse?

    let stockService: StockService
    
    init(stockService: StockService) {
        self.stockService = stockService
        Task{ await fetchOnAppear() }
    }
    
    func fetchOnAppear() async {
        await getAvailableYears()
        await getStocksForSelectedYear()
    }
    
    func getAvailableYears() async {
        do {
            self.years = try await stockService.getAvailableYears()
            selectedYear = years.last
        } catch {
            print(error)
        }
    }
    
    func getStocksForSelectedYear() async {
        // TODO: cache layer
        
        guard let selectedYear = self.selectedYear else {
            return
        }
        do {
            self.stocks = try await stockService.getStocksByYear(year: selectedYear)
        } catch let error as StockServiceError {
            handleStockServiceError(error)
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func calculatePurificationForYear() async throws {
        let year = Calendar.current.dateComponents([.year], from: startDate).year
        guard let code = selectedStock?.code, let stocksCountInt = Int(stocksCount) else {
            return
        }
        
        do {
            isLoadingAnswer = true
            self.response = try await stockService.calculatePurification(year: year!.description, request: .init(startDate: startDate, endDate: endDate, numberOfStocks: stocksCountInt, stockCode: code))
            isLoadingAnswer = false
        } catch let error as StockServiceError {
            isLoadingAnswer = false
            handleStockServiceError(error)
        } catch {
            isLoadingAnswer = false
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func handleStockServiceError(_ error: StockServiceError) {
        switch error {
        case .badURL:
            print("❌ Invalid URL. Please check the API endpoint.")
        case .decodingError:
            print("❌ Failed to decode data. The API response format might have changed.")
        case .apiError(let apiError):
            self.error = apiError
            print("❌ API Error: \(apiError.message)")
        case .unknownError(let message):
            print("❌ Unknown error: \(message)")
        }
    }

    
}
