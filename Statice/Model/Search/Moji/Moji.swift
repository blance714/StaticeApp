//
//  Moji.swift
//  Statice
//
//  Created by blance on 2023/3/24.
//

import Foundation
import SwiftUI

let MojiApplicationId = "E62VyFVLMiW7kvbtVq3p"

struct MojiApiResponse<T: Codable>: Codable {
    let result: T
}

struct MojiSearchResult: SearchResult {
    let id: String
    let title: String
    let excerpt: String
    let dictionary = Dictionary.Moji
    func getView(_ translationResult: TranslationResult?) -> AnyView {
        return AnyView(MojiResultView(searchResult: self, translationResult: translationResult))
    }
}

let MojiFieldVariables: [AnkiFieldVariable] = [
    .init(title: "单词", variable: "spell", systemImage: "quote.bubble"),
    .init(title: "读音", variable: "pron", systemImage: "speaker.wave.3"),
    .init(title: "音调", variable: "accent", systemImage: "music.note"),
    .init(title: "释义", variable: "define", systemImage: "character.book.closed"),
    .init(title: "词性", variable: "pos", systemImage: "tag"),
    .init(title: "音频", variable: "audio", systemImage: "tag"),
    .init(title: "例句", variable: "sentence", systemImage: "text.quote"),
    .init(title: "例句翻译", variable: "translation", systemImage: "globe"),
    .init(title: "例句音频", variable: "sentenceAudio", systemImage: "tag")
]

struct MojiFieldVariableMap {
    var spell: String?
    var pron: String?
    var accent: String?
    var define: String?
    var pos: String?
    var audio: String?
    var sentence: String?
    var translation: String?
    var sentenceAudio: String?
}

struct MojiFieldVariableConverter: AnkiFieldVariableConverter {
    let map: MojiFieldVariableMap
    
    func convert(_ text: String) -> String {
        switch(text) {
        case "spell":       return map.spell ?? ""
        case "pron":        return map.pron ?? ""
        case "accent":      return map.accent ?? ""
        case "define":      return map.define ?? ""
        case "pos":         return map.pos ?? ""
        case "audio":       return map.audio ?? ""
        case "sentence":    return map.sentence ?? ""
        case "translation": return map.translation ?? ""
        case "sentenceAudio":   return map.sentenceAudio ?? ""
        default:            return ""
        }
    }
}
