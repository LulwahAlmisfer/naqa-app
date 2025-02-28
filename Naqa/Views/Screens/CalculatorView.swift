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
    
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var showSheet = false
    
    var body: some View {
        @Bindable var router = router

        Form{
            Section("معلومات الشراء") {
                Button {
                    hideKeyboard()
                    router.calculatorRoutes.append(.search)
                } label: {
                    HStack {
                        if let code = model.selectedStock?.code {
                            CompanyLogoView(code: code)
                        }
                        Text(model.selectedStock?.name ?? "إختر شركة")
                        Spacer()
                        Image(systemName: "chevron.left")
                    }
                }
                
                TextField("عدد الأسهم", text: $model.stocksCount)
                    //.keyboardType(.asciiCapableNumberPad)
                // todo fix this 
                
                picker
                
            }
          
            HoldingPeriodView(daysCount: $model.daysCount, fromDate: $model.fromDate, toDate: $model.toDate)
            
            Button("إحسب") {
                hideKeyboard()
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
        .scaleEffect(x: self.layoutDirection == .rightToLeft ? -1 : 1)
        .toolbar { ToolbarItem(placement: .topBarLeading) { clearButton } }
        .alert(item: $model.error) { error in
            Alert(title: Text("حدث خطأ"), message: Text(error.message), dismissButton: .default(Text("اغلاق")))
        }
        .onChange(of: model.screen2SelectedYear) { _, _ in
            model.selectedStock = nil
            Task { await model.getStocksForScreen2SelectedYear() }
        }
    }
    
    var picker: some View {
        Button(action: { showSheet.toggle() }) {
            HStack {
                Text("إختر السنة")
                Spacer()
                  Text(model.screen2SelectedYear)
                      .foregroundColor(.primary)
                Image(systemName: "chevron.down")
                    .foregroundColor(.purple)
            }
            .padding(8)
        }
        .sheet(isPresented: $showSheet) {
            NavigationView {
                List(model.years.reversed(), id: \.self) { year in
                    Button(action: {
                        model.screen2SelectedYear = year
                        showSheet = false
                    }) {
                        HStack {
                            Text(year)
                            Spacer()
                            if model.screen2SelectedYear == year {
                                Image(systemName: "checkmark")
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .scaleEffect(x: self.layoutDirection == .rightToLeft ? -1 : 1)
                .navigationTitle("اختر السنة")
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
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
    @Environment(\.layoutDirection) private var layoutDirection

    
    var body: some View {
        
        List(model.screen2FilteredStocks.filter{$0.shariaOpinion != .Prohibited}) { stock in
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
        .scaleEffect(x: self.layoutDirection == .rightToLeft ? -1 : 1)
        .navigationTitle("الشركات")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $model.screen2SearchText,placement:.navigationBarDrawer(displayMode: .always))
    }
}
