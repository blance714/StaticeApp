//
//  AnkiData.swift
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

class AnkiDataModel: ObservableObject {
    @Published var ankiData: AnkiData? = nil
    
    private let dataFileName = "ankiData"
    
    init() {
        guard let codedData = try? Data(contentsOf: dataModelURL()) else {
            print("No local Anki Data found.")
            return
        }
        guard let decoded = try? JSONDecoder().decode(AnkiData.self, from: codedData) else {
            print("Failed to decode Anki Data json file.")
            return
        }
        ankiData = decoded
    }
    
    init(ankiData: AnkiData) {
        self.ankiData = ankiData
    }
    
    private func dataModelURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(dataFileName, conformingTo: .json)
    }
    
    func save() {
        guard let coded = try? JSONEncoder().encode(ankiData) else {
            print("Encode Anki data failed.")
            return
        }
        
        do {
            try coded.write(to: dataModelURL())
        } catch {
            print("Failed to save Anki data: \(error)")
        }
    }
}
