//
//  WebView.swift
//  Statice
//
//  Created by blance on 2023/4/1.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var url: URL
    let handleSearch: ((String, SentenceSelection) -> Void)?
    let handleTranslate: ((String) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, url: $url)
    }
    
    func makeUIView(context: Context) -> CustomWKWebView {
        print("233")
        let webView = CustomWKWebView(handleSearch: handleSearch, handleTranslate: handleTranslate)
        webView.navigationDelegate = context.coordinator
        
        webView.configuration.userContentController.add(ContentController(url: $url), name: "urlChanged")
        return webView
    }
    
    func updateUIView(_ webView: CustomWKWebView, context: Context) {
        if webView.url != url {
            print("load")
            webView.load(URLRequest(url: url))
        }
    }

    /// urlChange js handler
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

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: .constant(URL(string: "https://bing.com")!), handleSearch: nil, handleTranslate: nil)
    }
}
