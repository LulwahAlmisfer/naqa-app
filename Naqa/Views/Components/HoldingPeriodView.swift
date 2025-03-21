//
//  HoldingPeriodView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 22/02/2025.
//

import SwiftUI

struct HoldingPeriodView: View {
    @State private var selectionMode: SelectionMode = .dateRange
    @Binding var daysCount: String
    
    @Binding var fromDate: Date
    @Binding var toDate: Date
    
    enum SelectionMode: String, CaseIterable {
        case dateRange = "تحديد بالتواريخ"
        case daysCount = "تحديد بعدد الأيام"
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
                DatePicker(LocalizedStringKey("من"), selection: $fromDate, displayedComponents: .date)
                    .onChange(of: fromDate) { oldValue, newValue in
                        if newValue > toDate {
                            toDate = newValue
                        }
                    }
                
                DatePicker(LocalizedStringKey("إلى"), selection: $toDate, in: fromDate..., displayedComponents: .date)
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
            toDate = Calendar.current.date(byAdding: .day, value: days - 1, to: fromDate) ?? fromDate
        }
    }
}


