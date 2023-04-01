//
//  URLManager.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import Foundation

class URLManager: ObservableObject {
    @Published var url: URL
    
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
        print("handle")
    }
}
