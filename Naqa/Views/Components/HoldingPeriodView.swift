//
//  HoldingPeriodView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 22/02/2025.
//

import SwiftUI

struct HoldingPeriodView: View {
    @Binding var selectedYear: String
    @State private var selectionMode: SelectionMode = .dateRange
    @Binding var daysCount: String
    
    @Binding var fromDate: Date
    @Binding var toDate: Date
    
    enum SelectionMode: String, CaseIterable {
        case dateRange = "تحديد بالتواريخ"
        case daysCount = "تحديد بعدد الأيام"
    }
    
    private var minDate: Date {
        Calendar.current.date(from: DateComponents(year: 2015, month: 1, day: 1))!
    }
    
    private var maxDate: Date {
        let year = Int(selectedYear) ?? Calendar.current.component(.year, from: Date())
        return Calendar.current.date(from: DateComponents(year: year, month: 12, day: 31))!
    }
    
    var body: some View {
        Section(header: Text("فترة التملك")) {
            
            //TODO: add logic when changing the picker (with temp value)
            Picker("", selection: $selectionMode) {
                ForEach(SelectionMode.allCases, id: \.self) { mode in
                    Text(LocalizedStringKey(mode.rawValue))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .tint(.naqaLightPurple)
            
            if selectionMode == .dateRange {
                DatePicker(LocalizedStringKey("من"), selection: $fromDate, in: minDate...maxDate, displayedComponents: .date)
                    .onChange(of: fromDate) { oldValue, newValue in
                        if newValue > toDate {
                            toDate = newValue
                        }
                    }
                
                DatePicker(LocalizedStringKey("إلى"), selection: $toDate, in: minDate...maxDate , displayedComponents: .date)
            } else {
                CustomTextField("أدخل عدد الأيام", text: $daysCount)
                    .keyboardType(.asciiCapableNumberPad)
                    .onChange(of: daysCount) { oldValue, newValue in
                        updateToDate()
                    }
            }
        }
        
    }

    private func updateToDate() {
        if let days = Int(daysCount), days > 0 {
            let year = Int(selectedYear) ?? Calendar.current.component(.year, from: Date())
            

            let maxDate = Calendar.current.date(from: DateComponents(year: year, month: 12, day: 31))!
            

            let calculatedFrom = Calendar.current.date(byAdding: .day, value: -(days - 1), to: maxDate) ?? maxDate
            
            fromDate = max(calculatedFrom, minDate) 
            toDate = maxDate
        }
    }

}



#Preview {
    MainView()
}
