//
//  AnkiSettings.swift
//  Statice
//
//  Created by blance on 2023/4/3.
//

import Foundation
import SwiftUI

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
            print("Get Mapping:", "\(self.noteType)_\(dictionary)_\(field)", self.noteMapping["\(self.noteType)_\(dictionary)_\(field)"] ?? "")
            return self.noteMapping["\(self.noteType)_\(dictionary)_\(field)"] ?? ""
        } set: {
            print("Set Mapping:", "\(self.noteType)_\(dictionary)_\(field)", $0)
            //            self.objectWillChange.send()
            self.noteMapping["\(self.noteType)_\(dictionary)_\(field)"] = $0
        }
    }
}

class AnkiSettingsModel: ObservableObject {
    @Published var ankiSettings = AnkiSettings()
    
    private let dataFileName = "ankiSettings"
    
    init() {
        guard let codedData = try? Data(contentsOf: dataModelURL()) else {
            print("No local Anki settings found.")
            return
        }
        guard let decoded = try? JSONDecoder().decode(AnkiSettings.self, from: codedData) else {
            print("Failed to decode Anki settings json file.")
            return
        }
        ankiSettings = decoded
    }
    
    init(ankiSettings: AnkiSettings) {
        self.ankiSettings = ankiSettings
    }
    
    func update(with ankiData: AnkiData) {
        if (!ankiData.decks.contains{ $0.name == ankiSettings.deck }) {
            ankiSettings.deck = ankiData.decks[0].name
        }
        if (!ankiData.notetypes.contains{ $0.name == ankiSettings.noteType }) {
            ankiSettings.noteType = ankiData.notetypes[0].name
        }
    }
    
    private func dataModelURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(dataFileName, conformingTo: .json)
    }
    
    func save() {
        guard let coded = try? JSONEncoder().encode(ankiSettings) else {
            print("Encode Anki settings failed.")
            return
        }
        
        do {
            try coded.write(to: dataModelURL())
        } catch {
            print("Failed to save Anki settings: \(error)")
        }
    }
}
