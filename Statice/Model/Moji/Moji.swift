//
//  Moji.swift
//  Statice
//
//  Created by blance on 2023/3/24.
//

import Foundation

let MojiApplicationId = "E62VyFVLMiW7kvbtVq3p"

struct SearchResult: Identifiable, Hashable {
    var id: String
    var title: String
    var excerpt: String
}

struct MojiApiResponse<T: Codable>: Codable {
    let result: T
}

struct MojiResponseVariable: AnkiVariable {
    let response: FetchWordsResponse
}

struct MojiResponseVariables {
    let variables: [AnkiVariable] {
        
    }
}
