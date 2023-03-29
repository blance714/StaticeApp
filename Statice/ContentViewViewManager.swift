//
//  ContentViewViewManager.swift
//  DataTaskProgress
//
//  Created by blance on 2023/3/25.
//

import Foundation

import SwiftUI
import Combine

class SearchWordManager: ObservableObject {
    @Published var searchResult: [SearchResult] = []
    @Published var url: URL = URL(string: "https://www.bing.com")!
    
    func handleSearch(searchText: String, isBrowsingWebsite: Bool) {
        searchResult = []
        var request = URLRequest(
            url: URL(string: "https://api.mojidict.com/parse/functions/search-all")!)
        let requestBody =
            SearchAllRequest(text: text, types: [102], _ApplicationId: MojiApplicationId)
        let jsonData = try? JSONEncoder().encode(requestBody)

        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("fetch error")
            } else {
                if let json = try? JSONDecoder().decode(SearchAllResponse.self, from: data!) {
                    searchResult = json.result.result.word.searchResult.map { result in
                        SearchResult(
                            id: result.targetId,
                            title: result.title,
                            excerpt: result.excerpt) }
                }
            }
        }.resume()
    }
    
    private func handleWebsiteRequest(urlText: String) {
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
    
    private func handleWordSearch(text: String) {
        
    }
}
