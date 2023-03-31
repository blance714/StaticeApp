//
//  SearchAll.swift
//  Statice
//
//  Created by blance on 2023/3/29.
//

struct SearchAllResult: Codable {
    //    let code: Int
    let result: WordResult
    
    struct WordResult: Codable {
        let word: Word
        
        struct Word: Codable {
            let searchResult: [SearchResultItem]
            
            struct SearchResultItem: Codable {
                let targetId: String
                //                let targetType: Int
                let title: String
                let excerpt: String
                //                let isFree: Bool
            }
        }
    }
}

typealias SearchAllResponse = MojiApiResponse<SearchAllResult>

struct SearchAllRequest: Codable {
    let text: String
    let types: [Int]
    let _ApplicationId: String
}
