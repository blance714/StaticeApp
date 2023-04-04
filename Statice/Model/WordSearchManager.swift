//
//  WordSearchManager.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import Foundation

class WordSearchManager: ObservableObject {
    @Published var isSearching = false
    @Published var searchResult: [any SearchResult] = []
    @Published var translationResult: TranslationResult? = nil
    
    func handleSearch(searchText: String, sentenceSelection: SentenceSelection? = nil) {
        searchResult = []
        if searchText == "" { return }
        
        isSearching = true
        var request = URLRequest(
            url: URL(string: "https://api.mojidict.com/parse/functions/search-all")!)
        let requestBody =
        SearchAllRequest(text: searchText, types: [102], _ApplicationId: MojiApplicationId)
        let jsonData = try? JSONEncoder().encode(requestBody)
        
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        if let selection = sentenceSelection {
            handleTranslate(sentence: selection.sentence, bold: selection.bold)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("fetch error")
            } else {
                let string = String(data: data!, encoding: .utf8)
                print(string)
                DispatchQueue.main.async {
                    self.isSearching = false
                }
                if let json = try? JSONDecoder().decode(SearchAllResponse.self, from: data!) {
                    DispatchQueue.main.async {
                        self.searchResult = json.result.result.word.searchResult.map { result in
                            MojiSearchResult(
                                id: result.targetId,
                                title: result.title,
                                excerpt: result.excerpt
                            ) }
                        print(json)
                    }
                } else {
                    self.searchResult = []
                }
            }
        }.resume()
    }
    
    func handleTranslate(sentence: String, bold: String?) {
        translationResult = TranslationResult(sentence: sentence, bold: bold)
        youdaoTranslateSentence(param: sentence) { translation in
            print("callback")
            DispatchQueue.main.async {
                self.translationResult = TranslationResult(
                    sentence: sentence,
                    bold: bold,
                    translation: translation)
            }
        }
    }
}
