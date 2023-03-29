//
//  WordSearchManager.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import Foundation

class WordSearchManager: ObservableObject {
    @Published var searchResult: [SearchResult] = []
    
    func handleSearch(searchText: String) {
        searchResult = []
        var request = URLRequest(
            url: URL(string: "https://api.mojidict.com/parse/functions/search-all")!)
        let requestBody =
        SearchAllRequest(text: searchText, types: [102], _ApplicationId: MojiApplicationId)
        let jsonData = try? JSONEncoder().encode(requestBody)
        
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("fetch error")
            } else {
                let string = String(data: data!, encoding: .utf8)
                print(string)
                if let json = try? JSONDecoder().decode(SearchAllResponse.self, from: data!) {
                    self.searchResult = json.result.result.word.searchResult.map { result in
                        SearchResult(
                            id: result.targetId,
                            title: result.title,
                            excerpt: result.excerpt) }
                    print(json)
                }
            }
        }.resume()
    }
}
