//
//  Anki.swift
//  Statice
//
//  Created by blance on 2023/3/27.
//

import Foundation
import SwiftUI

class AnkiData: Codable, ObservableObject {
    let decks: [Deck]
    let notetypes: [NoteType]
    let profiles: [Profile]
    
    init(decks: [Deck], notetypes: [NoteType], profiles: [Profile]) {
        self.decks = decks
        self.notetypes = notetypes
        self.profiles = profiles
    }
    
    struct Deck: Codable, Hashable {
        let name: String
    }
    
    struct NoteType: Codable, Hashable {
        let name: String
        let kind: String
        let fields: [Field]
        
        struct Field: Codable, Hashable {
            let name: String
        }
    }
    
    struct Profile: Codable, Hashable {
        let name: String
    }
}

class AnkiSettings: ObservableObject {
    @Published var deck = ""
    @Published var noteType = ""
    
    var noteMapping: [String: String] = [:]
    
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        deck = try container.decode(String.self, forKey: .deck)
        noteType = try container.decode(String.self, forKey: .noteType)
        noteMapping = try container.decode([String: String].self, forKey: .noteMapping)
    }
    
    func getNoteMapping(dictionary: String, field: String) -> Binding<String> {
        return Binding<String> {
            self.noteMapping["\(self.noteType)_\(dictionary)_\(field)"] ?? ""
        } set: {
            self.objectWillChange.send()
            self.noteMapping["\(self.noteType)_\(dictionary)_\(field)"] = $0
        }
    }
}

extension AnkiSettings: Codable {
    enum CodingKeys: CodingKey {
        case deck
        case noteType
        case noteMapping
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deck, forKey: .deck)
        try container.encode(noteType, forKey: .noteType)
        try container.encode(noteMapping, forKey: .noteMapping)
    }
}

protocol AnkiVariable {
    let title: String
    let variable: String
    let image: UIImage?
}
