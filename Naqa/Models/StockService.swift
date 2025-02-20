//
//  StockService.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import Foundation

enum StockServiceError: Error {
    case badURL
    case decodingError
    case apiError(NaqaErrorResponse)
    case unknownError(String)
}

class StockService {
    
    let baseURL: URL
    
    init(baseURL: URL = URL(string:"https://naqa-api-36462279645.europe-west1.run.app")! ) {
        self.baseURL = baseURL
    }
    
    func getAvailableYears() async throws -> [String] {
        guard let url = URL(string: "/api/v1/stocks", relativeTo: baseURL) else {
            throw StockServiceError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            if let apiError = try? JSONDecoder().decode(NaqaErrorResponse.self, from: data) {
                throw StockServiceError.apiError(apiError)
            } else {
                throw StockServiceError.unknownError("Invalid error response format")
            }
        }

        do {
            let years = try JSONDecoder().decode(Year.self, from: data)
            return years.availableYears
        } catch {
            throw StockServiceError.decodingError
        }
    }

    func getStocksByYear(year: String) async throws -> [Stock] {
        guard let url = URL(string: "/api/v1/stocks/year/\(year)", relativeTo: baseURL) else {
            throw StockServiceError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            if let apiError = try? JSONDecoder().decode(NaqaErrorResponse.self, from: data) {
                throw StockServiceError.apiError(apiError)
            } else {
                throw StockServiceError.unknownError("Invalid error response format")
            }
        }

        do {
            let stocks = try JSONDecoder().decode(StockData.self, from: data)
            return stocks.stocks
        } catch {
            throw StockServiceError.decodingError
        }
    }


    func calculatePurification(year: String, request: CalculatePurificationRequest) async throws -> CalculatePurificationResponse {
        guard let url = URL(string: "/api/v1/stocks/year/\(year)/calculate-purification", relativeTo: baseURL) else {
            throw StockServiceError.badURL
        }
        let requestBody = try JSONEncoder().encode(request)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            
            if !(200...299).contains(httpResponse.statusCode) {
                if let apiError = try? JSONDecoder().decode(NaqaErrorResponse.self, from: data) {
                    throw StockServiceError.apiError(apiError)
                } else {
                    throw StockServiceError.unknownError("Invalid error response format")
                }
            }
        }

        do {
            return try JSONDecoder().decode(CalculatePurificationResponse.self, from: data)
        } catch {
            throw StockServiceError.decodingError
        }
        
    }
    
}
