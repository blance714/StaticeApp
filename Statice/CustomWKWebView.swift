//
//  CustomWKWebkit.swift
//  Statice
//
//  Created by blance on 2023/3/24.
//

import Foundation
import WebKit
import SwiftUI
import Combine

class CustomWKWebView: WKWebView {
    var handleSearch: ((String) -> Void)?
    
    init(handleSearch: ((String) -> Void)?) {
        self.handleSearch = handleSearch
        let configuration = WKWebViewConfiguration()
        super.init(frame: .zero, configuration: configuration)
        setupCustomMenu() 
        print("init wk")
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setupCustomMenu()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCustomMenu() {
        let customMenuItem = UIMenuItem(title: "自定义操作", action: #selector(customAction(_:)))
        UIMenuController.shared.menuItems = [customMenuItem]
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(customAction(_:)) {
            return true
        }
        return false
    }

    @objc func customAction(_ sender: Any?) {
        // 在这里执行你的自定义操作
        print("自定义操作")
        evaluateJavaScript("window.getSelection().toString()") { (result, error) in
            if let text = result as? String {
                self.handleSearch?(text)
            } else if let error = error {
                print("获取选中文本时出错：\(error)")
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    @Binding var url: URL
    let handleSearch: ((String) -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self, url: $url)
    }

    func makeUIView(context: Context) -> CustomWKWebView {
        print("233")
        let webView = CustomWKWebView(handleSearch: handleSearch)
        webView.navigationDelegate = context.coordinator
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.2 Mobile/15E148 Safari/604.1"
        
        webView.configuration.userContentController.add(ContentController(url: $url), name: "urlChanged")
        return webView
    }

    func updateUIView(_ webView: CustomWKWebView, context: Context) {
        if webView.url != url {
            print("load")
            webView.load(URLRequest(url: url))
        }
    }
    
    class ContentController: NSObject, WKScriptMessageHandler {
        @Binding var url: URL
        
        init(url: Binding<URL>) {
            _url = url
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "urlChanged", let urlString = message.body as? String {
                print("URL 变更：\(urlString)")
                if let url = URL(string: urlString) {
                    self.url = url
                }
            }
        }
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        @Binding var url: URL

        init(_ parent: WebView, url: Binding<URL>) {
            self.parent = parent
            _url = url
        }
        
        func changeURL(_ webView: WKWebView) {
            if let loadingUrl = webView.url {
                url = loadingUrl
            }
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("开始加载：\(String(describing: webView.url))")
            changeURL(webView)
        }
        
        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            print("接收到服务器重定向：\(String(describing: webView.url))")
            changeURL(webView)
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("网页内容开始到达：\(String(describing: webView.url))")
            
            let script = """
            (function() {
                var pushState = history.pushState;
                var replaceState = history.replaceState;

                history.pushState = function(state, title, url) {
                    pushState.apply(history, [state, title, url]);
                    window.dispatchEvent(new Event('locationchange'));
                };

                history.replaceState = function(state, title, url) {
                    replaceState.apply(history, [state, title, url]);
                    window.dispatchEvent(new Event('locationchange'));
                };

                window.addEventListener('locationchange', function() {
                    webkit.messageHandlers.urlChanged.postMessage(window.location.href);
                    alert("changed.")
                });

                window.addEventListener('popstate', function() {
                    webkit.messageHandlers.urlChanged.postMessage(window.location.href);
                    alert("changed.")
                });
            })();
            """
            webView.evaluateJavaScript(script, completionHandler: nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("加载完成：\(String(describing: webView.url))")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("加载失败：\(String(describing: webView.url)), Error: \(error.localizedDescription)")
        }
    }
}
