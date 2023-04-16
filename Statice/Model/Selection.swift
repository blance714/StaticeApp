//
//  Selection.swift
//  Statice
//
//  Created by blance on 2023/4/17.
//

import Foundation

struct SearchSelection: Codable {
    let selection: String
    let sentence: SentenceSelection
    let rect: CGRect
}

struct TranslateSelection: Codable {
    let selection: String
    let rect: CGRect
}

struct SentenceSelection: Codable {
    let sentence: String
    let bold: String
}
