//
//  StockService.swift
//  Naqa
//
//  Created by Lulwah almisfer on 18/02/2025.
//

import Foundation
import PostHog

enum StockServiceError: Error {
    case badURL
    case decodingError
    case apiError(NaqaErrorResponse)
    case unknownError(String)
}

class StockService {
    
    let primaryURL: URL
    let secondaryURL: URL
    
    init(primaryURL: URL = URL(string:"https://naqa-api-36462279645.europe-west1.run.app")!,
         secondaryURL: URL = URL(string:"https://naqa-api-gebxuwihkq-uc.a.run.app")!) {
        self.primaryURL = primaryURL
        self.secondaryURL = secondaryURL
    }
    

    private func performRequest(endpoint: String) async throws -> Data {
        // first try wtih
        if let primaryResult = try? await makeRequest(baseURL: primaryURL, endpoint: endpoint) {
            return primaryResult
        }
        
        // if not working, try
        print("try second")
        return try await makeRequest(baseURL: secondaryURL, endpoint: endpoint)
    }
    

    private func performRequest(endpoint: String, requestBody: Data) async throws -> Data {

        if let primaryResult = try? await makeRequest(baseURL: primaryURL, endpoint: endpoint, requestBody: requestBody) {
            return primaryResult
        }


        return try await makeRequest(baseURL: secondaryURL, endpoint: endpoint, requestBody: requestBody)
    }
    
    private func makeRequest(baseURL: URL, endpoint: String) async throws -> Data {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw StockServiceError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            if let apiError = try? JSONDecoder().decode(NaqaErrorResponse.self, from: data) {
                PostHogSDK.shared.capture("Error(\(endpoint)):" + apiError.message)
                throw StockServiceError.apiError(apiError)
            } else {
                PostHogSDK.shared.capture("Error(\(endpoint)): Unknown Error")
                throw StockServiceError.unknownError("Invalid error response format")
            }
        }
        
        return data
    }
    

    private func makeRequest(baseURL: URL, endpoint: String, requestBody: Data) async throws -> Data {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw StockServiceError.badURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(urlRequest.toCurl())
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            
            if !(200...299).contains(httpResponse.statusCode) {
                if let apiError = try? JSONDecoder().decode(NaqaErrorResponse.self, from: data) {
                    PostHogSDK.shared.capture("Error(\(endpoint)):" + apiError.message)
                    throw StockServiceError.apiError(apiError)
                } else {
                    PostHogSDK.shared.capture("Error(\(endpoint)): Unknown Error")
                    throw StockServiceError.unknownError("Invalid error response format")
                }
            }
        }
        
        return data
    }
    
    func getAvailableYears() async throws -> [String] {
        let data = try await performRequest(endpoint: "/api/v1/stocks")
        
        do {
            let years = try JSONDecoder().decode(Year.self, from: data)
            return years.availableYears
        } catch {
            throw StockServiceError.decodingError
        }
    }

    func getStocksByYear(year: String) async throws -> [Stock] {
        let data = try await performRequest(endpoint: "/api/v1/stocks/year/\(year)")
        
        do {
            let stocks = try JSONDecoder().decode(StockData.self, from: data)
            return stocks.stocks
        } catch {
            throw StockServiceError.decodingError
        }
    }

    func calculatePurification(year: String, request: CalculatePurificationRequest) async throws -> CalculatePurificationResponse {
        let requestBody = try JSONEncoder().encode(request)
        let data = try await performRequest(endpoint: "/api/v1/stocks/year/\(year)/calculate-purification", requestBody: requestBody)
        
        do {
            return try JSONDecoder().decode(CalculatePurificationResponse.self, from: data)
        } catch {
            PostHogSDK.shared.capture("Error(calculatePurification): decodingError Error")
            throw StockServiceError.decodingError
        }
    }
}
