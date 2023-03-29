//
//  AnkiModel.swift
//  Statice
//
//  Created by blance on 2023/3/27.
//

import Foundation

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
