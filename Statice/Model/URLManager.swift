//
//  URLManager.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import Foundation
import WebKit
import Combine

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
    
    var callAsyncJavaScript: ((
        String, [String : Any], WKFrameInfo?, WKContentWorld, ((Result<Any, Error>) -> Void)?
    ) -> Void)?
    
    @Published var isReaderModeEnabled: Bool = false
    @Published var isReaderModeAvaliable: Bool = false
    var convertReaderModeData: (() -> AnyPublisher<ReaderData, Never>)?
    
    var didFinishPublisher = PassthroughSubject<Void, Never>()
    var didFinishCancellable: AnyCancellable? = nil
    
    init(url: URL = Bundle.main.url(forResource: "intro", withExtension: "html") ?? URL(string: "about:blank")!) {
        self.url = url
        
//        didFinishCancellable = didFinishPublisher.sink {
//            self.checkIfReaderModeAvaliable()
//        }
    }
    
    func handleURLRequest(urlText: String) {
        if var url = URL(string: urlText) {
            if url.scheme == nil {
                url = URL(string: "https://\(url.absoluteString)")!
            }
            self.url = url
        } else {
            self.url =  URL(string: "about:blank")!
        }
    }
    
    func handleURLRequest(url: URL?) {
        if let url = url {
            self.url = url
        }
    }
    
    var cancellable: AnyCancellable?
    func setupWebView(_ webView: WKWebView, _ coordinator: WebView.Coordinator) {
        goBack = { webView.goBack() }
        goForward = { webView.goForward() }
        reload = { webView.reload() }
        stopLoading = { webView.stopLoading() }
        callAsyncJavaScript = webView.callAsyncJavaScript(_:arguments:in:in:completionHandler:)
        
        cancellable = coordinator.didFinishPublisher.subscribe(didFinishPublisher)
        
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
                print("URL: \(String(describing: url)), isLoading: \(webView.isLoading)")
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
    
    func callScript(_ script: String, arguments: [String : Any] = [:], handler: ((Result<Any, Error>) -> Void)?) {
        guard let call = callAsyncJavaScript else {
            return
        }
        
        call(script, arguments, nil, .page, handler);
    }
    
    func checkIfReaderModeAvaliable() {
        ReaderModeList.forEach { readerMode in
            if url.absoluteString.contains(readerMode.pattern) {
                self.isReaderModeAvaliable = true
                convertReaderModeData = {
                    readerMode.convert(self)
                        .catch { error in
                            self.isReaderModeAvaliable = false
                            self.isReaderModeEnabled = false
                            self.convertReaderModeData = nil
                            return Just(ReaderData(article: "Cannot fetch novel content."))
                        }
                        .assertNoFailure()
                        .eraseToAnyPublisher()
                }
            }
        }
    }
}
