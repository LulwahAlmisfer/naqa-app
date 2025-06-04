//
//  AsyncCompanyLogoView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 01/03/2025.
//

import SwiftUI


struct AsyncCompanyLogoView: View {
    var ticker: String
    var urlString: String {
      "https://web.alrajhi-capital.sa/stock-images/\(ticker).webp"
    }
    
    var body: some View {
        AsyncImage(url: URL(string: urlString), transaction: Transaction(animation: .easeInOut)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .empty:
                ProgressView()
                
            case .failure:
                placeHolderView
                
            @unknown default:
                placeHolderView
            }
        }
        .frame(width: 30, height: 30)
        .clipShape(.circle)
        
    }
    
    var placeHolderView: some View {
        Group {
            if UIImage(named: ticker) != nil {
                Image(ticker)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 30, height: 30)
                    
                    Text(ticker)
                        .bold()
                        .foregroundColor(.white)
                        .font(.caption2)
                }
            }
        }
    }
    
}
