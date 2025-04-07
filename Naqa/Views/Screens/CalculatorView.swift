//
//  CalculatorView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 19/02/2025.
//

import SwiftUI

struct CalculatorView: View {
    @EnvironmentObject private var model: Model
    @Environment(Router.self) private var router
    @State private var selectedDates: Set<DateComponents> = []

    
    
    var body: some View {
        @Bindable var router = router

        VStack{
            
            Button {
                router.calculatorRoutes.append(.search)
            } label: {
                Text(model.selectedStock?.name ?? "إختر شركة")
            }
            
            picker
            
            TextField("عدد الأسهم", text: $model.stocksCount)
         
            DatePicker("start date", selection: $model.startDate,displayedComponents: [.date])
                .datePickerStyle(.compact)
            DatePicker("end date", selection: $model.endDate,displayedComponents: [.date])
                .datePickerStyle(.compact)

            
            Button("calculate") {
                Task{ try await model.calculatePurificationForYear() }
            }
            
            if model.isLoadingAnswer {
                ProgressView()
            }
            
            if let result = model.response {
                Text(result.purificationAmount.description)
                Text(result.purificationRate.description)
                Text(result.daysHeld.description)
            }
        }
        .padding()
        .alert(item: $model.error) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
    
    var picker: some View {
        Picker("اختر السنة", selection: $model.selectedYear) {
              ForEach(model.years, id: \.self) { year in
                  Text(year).tag(year)
              }
          }
      }
}

struct SearchCompaniesView: View {
    @EnvironmentObject private var model: Model
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        
        List(model.stocks) { stock in
            Button{
                model.selectedStock = stock
                dismiss()
            }label: {
                HStack {
                    Image(stock.code)
                        .resizable()
                        .frame(width: 30,height: 30)
                        .clipShape(.circle)
                    Text(stock.name)
                }
            }
        }
        .navigationTitle("الشركات")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: .constant(""))
    }
}
