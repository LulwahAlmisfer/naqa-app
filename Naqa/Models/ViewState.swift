//
//  ViewState.swift
//  Naqa
//
//  Created by Lulwah almisfer on 01/03/2025.
//

import Foundation
import SwiftUI

enum ViewState: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none): return true
        case (.done, .done): return true
        case (.loading, .loading): return true
        case (.empty, .empty): return true
        case (.failed, .failed): return true
        default: return false
        }
    }
    case none
    case done
    case loading
    case empty
    case failed(_ failureMessage: FailureMessage? = nil, error: Error? = nil)
    
    func isViewState(_ viewState: ViewState) -> Bool {
        self == viewState
    }
}

extension ViewState {
    
    struct FailureMessage {
        let title: String?
        let message: String?
        let icon: Image?
        let retryAction: (() -> Void)?
        
        init(title: String? = nil,
             message: String? = nil,
             icon: Image? = nil,
             retryAction: (() -> Void)? = nil) {
            self.title = title
            self.message = message
            self.icon = icon
            self.retryAction = retryAction
        }
    }
    
}
