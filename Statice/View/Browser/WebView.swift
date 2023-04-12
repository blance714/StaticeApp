//
//  WebView.swift
//  Statice
//
//  Created by blance on 2023/4/1.
//

import Foundation
import SwiftUI
import WebKit
import Combine

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
        
        webView.navigationDelegate = context.coordinator
        
        urlManager.setupWebView(webView, context.coordinator)
        
        return webView
    }
    
    func updateUIView(_ webView: CustomWKWebView, context: Context) {
        if webView.url != urlManager.url {
            webView.load(URLRequest(url: urlManager.url))
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        @ObservedObject var urlManager: URLManager
        
        init(_ parent: WebView, urlManager: ObservedObject<URLManager>) {
            self.parent = parent
            _urlManager = urlManager
        }
        
        func setupObservation(_ webView: WKWebView) {
            urlManager.setupObservation(webView)
        }
        
        var didFinishPublisher = PassthroughSubject<Void, Never>()
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            didFinishPublisher.send()
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(urlManager: URLManager(url: URL(string: "https://chen03.github.io")!), handleSearch: nil, handleTranslate: nil)
    }
}
