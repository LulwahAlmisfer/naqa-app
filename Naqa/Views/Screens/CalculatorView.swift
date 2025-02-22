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
    
    
    var body: some View {
        @Bindable var router = router

        Form{
            
            Button {
                router.calculatorRoutes.append(.search)
            } label: {
                Text(model.selectedStock?.name ?? "إختر شركة")
            }
            
            picker
            
            TextField("عدد الأسهم", text: $model.stocksCount)
         
            HoldingPeriodView(daysCount: $model.daysCount, fromDate: $model.fromDate, toDate: $model.toDate)
            
            Button("إحسب") {
                Task{ try await model.calculatePurificationForYear() }
            }
            .disabled(model.stocksCount.isEmpty)
            
            if model.isLoadingAnswer {
                ProgressView()
            }
            
            if let result = model.response {
                Text("مبلغ التطهير: \(result.purificationAmount.description)")
                Text("نسبة التطهير: \(result.purificationRate.description)")
                Text("عدد أيام الاحتفاظ: \(result.daysHeld.description)")
            }
        }
        .alert(item: $model.error) { error in
            Alert(title: Text("حدث خطأ"), message: Text(error.message), dismissButton: .default(Text("اغلاق")))
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                clearButton
            }
        }
    }
    
    var picker: some View {
        Picker("اختر السنة", selection: $model.screen2SelectedYear) {
              ForEach(model.years, id: \.self) { year in
                  Text(year).tag(year)
              }
          }
      }
    
    var clearButton: some View {
        Button("مسح"){
            model.clear()
        }
    }
    
}

struct SearchCompaniesView: View {
    @EnvironmentObject private var model: Model
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        
        List(model.screen2FilteredStocks) { stock in
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
        .searchable(text: $model.screen2SearchText,placement:.navigationBarDrawer(displayMode: .always))
    }
}
