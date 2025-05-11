//
//  CompanyLogoView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 28/02/2025.
//

import SwiftUI

struct CompanyLogoView: View {
    var code : String
    var imageURL : String? //todo
    var body: some View {
        if UIImage(named: code) != nil {
            Image(code)
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
        } else {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 30, height: 30)
                
                Text(code)
                    .bold()
                    .foregroundColor(.white)
                    .font(.caption2)
            }
        }
    }
}

#Preview {
    CompanyLogoView(code: "2122")
}
