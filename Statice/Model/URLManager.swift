//
//  URLManager.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import Foundation
import WebKit

class URLManager: ObservableObject {
    @Published var url: URL
    @Published var title: String?
    @Published var estimatedProgress: Double = 0
    
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var isLoading: Bool = false
    
    var goBack: (() -> Void)?
    var goForward: (() -> Void)?
    var reload: (() -> Void)?
    var stopLoading: (() -> Void)?
    
    init(url: URL = URL(string: "about:blank")!) {
        self.url = url
    }
    
    func handleURLRequest(urlText: String) {
        var url = URL(string: urlText)
        if var url = url {
            if url.scheme == nil {
                url = URL(string: "https://\(url.absoluteString)")!
            }
            self.url = url
        } else {
            self.url =  URL(string: "about:blank")!
        }
    }
    
    func setupWebView(_ webView: WKWebView) {
        goBack = { webView.goBack() }
        goForward = { webView.goForward() }
        reload = { webView.reload() }
        stopLoading = { webView.stopLoading() }
        
        setupObservation(webView)
    }
    
    var urlObserver: NSKeyValueObservation?
    var titleObserver: NSKeyValueObservation?
    var estimatedProgressObserver: NSKeyValueObservation?
    var isLoadingObserver: NSKeyValueObservation?
    var canGoBackObserver: NSKeyValueObservation?
    var canGoForwardObserver: NSKeyValueObservation?
    func setupObservation(_ webView: WKWebView) {
        urlObserver = webView.observe(\.url, options: .new) { webView, change in
            if let url = change.newValue! {
                print("URL: \(String(describing: url))")
                DispatchQueue.main.async {
                    self.url = url
                }
            }
        }
        titleObserver = webView.observe(\.title, options: .new) { _, change in
            self.title = change.newValue!
        }
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: .new) { _, change in
            DispatchQueue.main.async {
                self.estimatedProgress = change.newValue!
            }
        }
        isLoadingObserver = webView.observe(\.isLoading, options: .new) { _, change in
            DispatchQueue.main.async {
                self.isLoading = change.newValue!
            }
        }
        canGoBackObserver = webView.observe(\.canGoBack, options: .new) { _, change in
            self.canGoBack = change.newValue!
        }
        canGoForwardObserver = webView.observe(\.canGoForward, options: .new) { _, change in
            self.canGoForward = change.newValue!
        }
    }
}
