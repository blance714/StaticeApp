//
//  search_v3.swift
//  Statice
//
//  Created by blance on 2023/3/29.
//

///Request of search_v3 API
struct SearchRequest: Codable {
    var searchText: String
    var _ApplicationId: String
}

///The response of search_v3 API
struct SearchResponse: Codable {
    let result: SearchResult
    
    struct SearchResult: Codable {
        let originalSearchText: String
        let searchResults: [SearchResultItem]
        
        struct SearchResultItem: Codable {
            let searchText: String
            let count: Int
            let tarId: String
            let title: String
            let type: Int
            let createdAt: String
            let isChecked: Bool
            let pre_tokens: [String]
            let suf_tokens: [String]
            let excerpt: String
            let isFree: Bool
        }
    }
}
