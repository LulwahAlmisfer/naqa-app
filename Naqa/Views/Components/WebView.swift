//
//  WebView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 11/03/2025.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let onDismiss: () -> Void
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Optionally, do something when the WebView finishes loading
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Nothing needs to be updated for now
    }
}

struct WebViewWithBackButton: View {
    let url: URL
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the current view
    
    var body: some View {

            WebView(url: url) {
                // You can handle additional actions when the WebView is dismissed here
            }
    }
}
