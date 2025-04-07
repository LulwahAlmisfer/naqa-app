//
//  NaqaErrorResponse.swift
//  Naqa
//
//  Created by Lulwah almisfer on 20/02/2025.
//

import Foundation

struct NaqaErrorResponse: Codable,Identifiable {
    var id = UUID()
    let status: String
    let code: String
    let message: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.status = try container.decode(String.self, forKey: .status)
        self.code = try container.decode(String.self, forKey: .code)
        self.message = try container.decode(String.self, forKey: .message)
    }
}
