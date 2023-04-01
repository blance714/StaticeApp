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

class AnkiSettings: ObservableObject, Codable {
    @Published var deck = ""
    @Published var noteType = ""
    @Published var allowAddingSameNote = false
    var noteMapping: [String: String] = [:]

    init() {}
    init(deck: String, noteType: String, noteMapping: [String: String]) {
        self.deck = deck
        self.noteType = noteType
        self.noteMapping = noteMapping
    }

    func getNoteMapping(dictionary: String, field: String) -> Binding<String> {
        return Binding<String> {
            self.noteMapping["\(self.noteType)_\(dictionary)_\(field)"] ?? ""
        } set: {
//            self.objectWillChange.send()
            self.noteMapping["\(self.noteType)_\(dictionary)_\(field)"] = $0
        }
    }
}

//class AnkiSettings: ObservableObject {
//    @Published var deck = ""
//    @Published var noteType = ""
//
//    @Published var allowAddingSameNote = false
//
//    var noteMapping: [String: String] = [:]
//
//    init() {}
//    init(deck: String, noteType: String, noteMapping: [String: String]) {
//        self.deck = deck
//        self.noteType = noteType
//        self.noteMapping = noteMapping
//    }
//    required init(from decoder: Decoder) throws {
//        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
//            deck = (try? container.decode(String.self, forKey: .deck)) ?? self.deck
//            noteType = (try? container.decode(String.self, forKey: .noteType)) ?? self.noteType
//            noteMapping = (try? container.decode([String: String].self, forKey: .noteMapping)) ?? self.noteMapping
//            allowAddingSameNote = (try? container.decode(Bool.self, forKey: .allowAddingSameNote)) ?? self.allowAddingSameNote
//        }
//    }
//
//    func getNoteMapping(dictionary: String, field: String) -> Binding<String> {
//        return Binding<String> {
//            self.noteMapping["\(self.noteType)_\(dictionary)_\(field)"] ?? ""
//        } set: {
//            self.objectWillChange.send()
//            self.noteMapping["\(self.noteType)_\(dictionary)_\(field)"] = $0
//        }
//    }
//}
//
//extension AnkiSettings: Codable {
//    enum CodingKeys: CodingKey {
//        case deck
//        case noteType
//        case noteMapping
//        case allowAddingSameNote
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(deck, forKey: .deck)
//        try container.encode(noteType, forKey: .noteType)
//        try container.encode(noteMapping, forKey: .noteMapping)
//        try container.encode(allowAddingSameNote, forKey: .allowAddingSameNote)
//    }
//}
