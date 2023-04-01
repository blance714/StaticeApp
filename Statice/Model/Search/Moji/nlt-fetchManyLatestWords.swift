//
//  nlt-fetchManyLatestWords.swift
//  Statice
//
//  Created by blance on 2023/3/29.
//

///Response of nlt-fetchManyLatestWords
struct MojiFetchWordsResponse: Codable {
    var result: Result
    
    struct Result: Codable {
//        var one: [String]
        var result: [Word]
        var code: Int
        
        enum CodingKeys: String, CodingKey {
            case result = "result"
            case code = "code"
        }
        
        struct Word: Codable {
            let word: WordInfo
            let details: [Detail]
            let subdetails: [Subdetail]
            let examples: [Example]
            
            struct WordInfo: Codable {
                let excerpt: String?
                let spell: String?
                let accent: String?
                let pron: String?
                //                let romaji: String
                //                let createdAt: String
                //                let updatedAt: String
                //                let tags: String
                //                let outSharedNum: Int
                //                let isFree: Bool
                //                let quality: Int
                //                let isChecked: Bool
                //                let reportedAt: IsoDate
                //                let reportedNum: Int
                //                let checkedAt: IsoDate
                //                let viewedNum: Int
                //                let objectId: String
            }
            
            //            struct IsoDate: Codable {
            //                let __type: String
            //                let iso: String
            //            }
            
            struct Detail: Codable {
                let title: String
                //                let index: Int
                //                let createdAt: String
                //                let updatedAt: String
                //                let wordId: String
                //                let objectId: String
            }
            
            struct Subdetail: Codable, Identifiable {
                let title: String
                //                let index: Int
                //                let createdAt: String
                //                let updatedAt: String
                //                let wordId: String
                //                let detailsId: String
                let id: String
                
                enum CodingKeys: String, CodingKey {
                    case title
                    //, index, createdAt, updatedAt, wordId, detailsId
                    case id = "objectId"
                }
            }
            
            struct Example: Codable, Identifiable {
                let title: String
                //                let index: Int
                let trans: String
                //                let createdAt: String
                //                let updatedAt: String
                //                let wordId: String
                let subdetailsId: String
                //                let isFree: Bool
                //                let quality: Int
                //                let isChecked: Bool
                //                let viewedNum: Int
                let id: String
                //                let notationTitle: String
                
                enum CodingKeys: String, CodingKey {
                    case title, trans, subdetailsId
                    //index, createdAt, updatedAt, wordId, isFree, quality, isChecked, viewedNum, notationTitle
                    case id = "objectId"
                }
            }
        }
    }
}

struct MojiFetchWordsRequest: Codable {
    let itemsJson: [ItemJson]
    let skipAccessories: Bool
    let _ApplicationId: String
    
    struct ItemJson: Codable {
        let objectId: String
    }
}
