//
//  WebView.swift
//  Statice
//
//  Created by blance on 2023/4/1.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @ObservedObject var urlManager: URLManager
    let handleSearch: ((String, SentenceSelection) -> Void)?
    let handleTranslate: ((String) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, urlManager: _urlManager)
    }
    
    func makeUIView(context: Context) -> CustomWKWebView {
        let webView = CustomWKWebView(handleSearch: handleSearch, handleTranslate: handleTranslate)
        webView.allowsBackForwardNavigationGestures = true
        
        
        urlManager.setupWebView(webView)
        
        return webView
    }
    
    func updateUIView(_ webView: CustomWKWebView, context: Context) {
        if webView.url != urlManager.url {
            webView.load(URLRequest(url: urlManager.url))
        }
    }

    class Coordinator: NSObject {
        var parent: WebView
        @ObservedObject var urlManager: URLManager
        
        init(_ parent: WebView, urlManager: ObservedObject<URLManager>) {
            self.parent = parent
            _urlManager = urlManager
        }
        
        func setupObservation(_ webView: WKWebView) {
            urlManager.setupObservation(webView)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(urlManager: URLManager(url: URL(string: "https://chen03.github.io")!), handleSearch: nil, handleTranslate: nil)
    }
}
