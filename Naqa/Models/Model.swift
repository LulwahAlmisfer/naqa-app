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
    @Published var fromDate: Date = .now
    @Published var toDate: Date = .now

    @Published var screen1SelectedYear: String = "2015"
    @Published var screen2SelectedYear: String = "2015"
    @Published var years: [String] = []
    
    
    @Published var screen1Stocks: [Stock] = []
    @Published var screen2Stocks: [Stock] = []
    
    @Published var screen1SearchText: String = ""
    @Published var screen2SearchText: String = ""

    var screen1FilteredStocks: [Stock] {
        if screen1SearchText.isEmpty {
            return screen1Stocks
        }
        return screen1Stocks.filter { $0.name.localizedCaseInsensitiveContains(screen1SearchText) }
    }

    var screen2FilteredStocks: [Stock] {
        if screen2SearchText.isEmpty {
            return screen2Stocks
        }
        return screen2Stocks.filter { $0.name.localizedCaseInsensitiveContains(screen2SearchText) }
    }
    
    
    @Published var response: CalculatePurificationResponse? = nil
    @Published var selectedStock: Stock?
    @Published var stocksCount: String = ""
    @Published var daysCount: String = ""

    @Published var isLoadingAnswer: Bool = false
    @Published var error: NaqaErrorResponse?

    let stockService: StockService
    
    init(stockService: StockService) {
        self.stockService = stockService
        Task{ await fetchOnAppear() }
    }
    
    func fetchOnAppear() async {
        await getAvailableYears()
        await getStocksForScreen1SelectedYear()
        await getStocksForScreen2SelectedYear()
    }
    
    func getAvailableYears() async {
        do {
            self.years = try await stockService.getAvailableYears()
            if let lastYear = years.last {
                self.screen1SelectedYear = lastYear
                self.screen2SelectedYear = lastYear
                
                fromDate = lastYear.firstDayOfYear()
                toDate = lastYear.lastDayOfYear()
            }
        } catch {
            print(error)
        }
    }
    
    func getStocksForScreen1SelectedYear() async {
        // TODO: cache layer

        do {
            let stocks = try await stockService.getStocksByYear(year: screen1SelectedYear)
            self.screen1Stocks = stocks.sorted{$0.shariaOpinion.order < $1.shariaOpinion.order}
        } catch let error as StockServiceError {
            handleStockServiceError(error)
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func getStocksForScreen2SelectedYear() async {
        // TODO: cache layer

        do {
            let stocks = try await stockService.getStocksByYear(year: screen2SelectedYear)
            self.screen2Stocks = stocks.sorted{$0.shariaOpinion.order < $1.shariaOpinion.order}
        } catch let error as StockServiceError {
            handleStockServiceError(error)
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func calculatePurificationForYear() async throws {
        
        guard let code = selectedStock?.code, let stocksCountInt = Int(stocksCount) else {
            return
        }
        
        do {
            isLoadingAnswer = true
            self.response = try await stockService.calculatePurification(year: screen2SelectedYear, request: .init(startDate: fromDate, endDate: toDate.addOneDay(), numberOfStocks: stocksCountInt, stockCode: code))
            isLoadingAnswer = false
        } catch let error as StockServiceError {
            isLoadingAnswer = false
            handleStockServiceError(error)
        } catch {
            isLoadingAnswer = false
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func clear() {
        response = nil
        fromDate = screen2SelectedYear.firstDayOfYear()
        toDate = screen2SelectedYear.lastDayOfYear()
        stocksCount = ""
        daysCount = ""
        selectedStock = nil
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
