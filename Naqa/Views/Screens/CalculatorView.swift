//
//  CalculatorView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 19/02/2025.
//

import SwiftUI
import PostHog

struct CalculatorView: View {
    @EnvironmentObject private var model: Model
    @Environment(Router.self) private var router
    @Environment(\.colorScheme) var colorScheme

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
                        if let stock = model.selectedStock {
                            AsyncCompanyLogoView(ticker: stock.code, urlString:stock.logo )
                        }
                        Text(LocalizedStringKey((Helper.isCurrentLanguageArabic() ? model.selectedStock?.name_ar : model.selectedStock?.name_en) ?? "إختر الشركة"))
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                        Spacer()
                        Image(systemName: "chevron.left")
                            .rotationEffect(layoutDirection == .leftToRight ? Angle(degrees: 180) : Angle(degrees: 0))
                    }
                }
                
                CustomTextField("عدد الأسهم", text: $model.stocksCount)
                                 .keyboardType(.asciiCapableNumberPad)
                
             //  picker
                
            }
          
            HoldingPeriodView(selectedYear: $model.screen2SelectedYear, daysCount: $model.daysCount, fromDate: $model.fromDate, toDate: $model.toDate)
            
            calculate
            
            if model.isLoadingAnswer {
                progressView
            } else if let result = model.response {
                VStack(spacing: 20) {
                    HStack {
                        Text("مبلغ التطهير")
                        Spacer()
                        Text(result.purificationAmount.rounded(to: 4))
                        Image("sar")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.naqaLightPurple)
                            .frame(width: 15, height: 15)
                    }
                    
                    HStack {
                        Text("نسبة التطهير")
                        Spacer()
                        Text("%\(result.purificationRate.rounded(to: 4))")
                    }
                    

                    if let yearly = result.yearlyBreakdown, !yearly.isEmpty {
                        Divider()
                        VStack(alignment: .leading, spacing: 12) {
                            Text(.init("تفصيل سنوي"))
                                .font(.headline)
                            ForEach(yearly) { year in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("\(Double(year.year).rounded(to: 0)) - \(Helper.isCurrentLanguageArabic() ? year.companyNameAr : year.companyNameEn)")
                                        Spacer()
                                        Text("%\(year.purificationRate.rounded(to: 4))")
                                    }
                                    HStack {
                                        Text(.init("Yealy_Purification_Amount"))
                                        Spacer()
                                        Text(year.purificationAmount.rounded(to: 4))
                                        Image("sar")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundStyle(.naqaLightPurple)
                                            .frame(width: 15, height: 15)
                                    }
                                    HStack {
                                        Text(.init("Days_In_Period"))
                                        Spacer()
                                        Text("\(year.daysInPeriod)")
                                    }
                                    HStack {
                                        Text(.init("Sharing_Opinion"))
                                        Spacer()
                                        Text(.init(year.shariaOpinion))
                                    }
                                }
                                .padding(.vertical, 6)
                                Divider()
                            }
                        }
                    }
                    
                    if PostHogSDK.shared.isFeatureEnabled("EHSAN") {
                        ehsan
                    }
                }
                .padding()
            }

        }
        .logEvent("CalculatorView_Opened")
        .toolbar { ToolbarItem(placement: .topBarLeading) { clearButton } }
        .alert(item: $model.error) { error in
            Alert(title: Text("حدث خطأ"), message: Text(error.message), dismissButton: .default(Text("اغلاق")))
        }
        .onChange(of: model.screen2SelectedYear) { _, _ in
            model.selectedStock = nil
            Task { await model.getStocksForScreen2SelectedYear() }
        }

    }
    
    var calculate: some View {
        Group {
            if model.response == nil {
                Button("إحسب") {
                    PostHogSDK.shared.capture("Calculate_Button_Tapped")
                    hideKeyboard()
                    Task{ try await model.calculatePurificationForYear() }
                }
                .disabled(model.stocksCount.isEmpty || model.selectedStock == nil)
                
            } else {
                Button {
                    model.clear()
                } label: {
                    HStack {
                    Spacer()
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundStyle(.naqaLightPurple)
                    }
                }
            }
        }
    }
    
    var progressView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    var picker: some View {
        Menu {
            ForEach(model.years.reversed(), id: \.self) { year in
                Button(action: { model.screen2SelectedYear = year }) {
                    HStack {
                        Text(year)
                        if model.screen2SelectedYear == year {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        label: {
            HStack {
                Text(model.screen2SelectedYear)
                    .foregroundColor(.primary)
                Image(systemName: "chevron.up.chevron.down")
                    .foregroundColor(.naqaLightPurple)
            }
            .padding(8)
        }
    }

    var clearButton: some View {
        Button("مسح"){ model.clear() }
            .tint(.accent)
    }
    
    var ehsan: some View {
        Link(destination: URL(string: "https://ehsan.sa/stockspurification")!) {
            HStack {
                Image("ehsan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .background(.white)
                    .clipShape(.circle)

                Text("تبرع بخدمة إحسان لتطهير الأسهم")
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.left")
                    .rotationEffect(layoutDirection == .leftToRight ? Angle(degrees: 180) : Angle(degrees: 0))
            }
        }.onTapGesture {
            PostHogSDK.shared.capture("CLICKED_DONATE_EHSAN")
        }
    }
}

struct SearchCompaniesView: View {
    @EnvironmentObject private var model: Model
    @Environment(\.dismiss) private var dismiss
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Group {
            switch model.viewState {
            case .loading, .done, .empty, .none:
                companyList
            case .failed(let message, let error):
                failureView(message: message, error: error)
            }
        }
        .navigationTitle("الشركات")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $model.screen2SearchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "إبحث بالاسم أو الرمز"
        )
    }


    var companyList: some View {
        List(model.screen2FilteredStocks.filter { $0.shariaOpinion != .Prohibited }) { stock in
            Button {
                model.selectedStock = stock
                dismiss()
            } label: {
                HStack {
                    AsyncCompanyLogoView(ticker: stock.code, urlString: stock.logo)

                    VStack(alignment: .leading) {
                        Text(Helper.isCurrentLanguageArabic() ? stock.name_ar : stock.name_en)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .font(.system(size: Helper.isCurrentLanguageArabic() ? 17 : 13))

                        Text(stock.code)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func failureView(message: ViewState.FailureMessage?, error: Error?) -> some View {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            FailureView(message: "No Internet Connection. Please check your network.") {
                Task { await model.fetchOnAppear() }
            }
        } else {
            FailureView(message: message?.message ?? "Something went wrong") {
                Task { await model.fetchOnAppear() }
            }
        }
    }
}


#Preview {
    MainView()
}
