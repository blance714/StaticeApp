//
//  DataModel.swift
//  Statice
//
//  Created by blance on 2023/4/3.
//

import Foundation
import Combine

protocol DefaultInit {
    init()
}

class DataModel<T: ObservableObject & Codable & DefaultInit>: ObservableObject {
    @Published var data: T
    
    private let dataFileName: String
    
    init(dataFileName: String) {
        self.data = T()
        self.dataFileName = dataFileName
        guard let codedData = try? Data(contentsOf: dataModelURL()) else {
            print("No local \(dataFileName) settings found.")
            return
        }
        guard let decoded = try? JSONDecoder().decode(T.self, from: codedData) else {
            print("Failed to decode \(dataFileName) settings json file.")
            return
        }
        data = decoded
        
        bindPublisher()
    }
    
    init(dataFileName: String, data: T) {
        self.data = data
        self.dataFileName = dataFileName
        
        bindPublisher()
    }
    
    private var anyCancellable: AnyCancellable?
    func bindPublisher() {
        anyCancellable = data.objectWillChange.sink { _ in
            print("objectWillChange")
            self.objectWillChange.send()
        }
    }
    
    private func dataModelURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(dataFileName, conformingTo: .json)
    }
    
    func save() {
        guard let coded = try? JSONEncoder().encode(data) else {
            print("Encode \(dataFileName) settings failed.")
            return
        }
        
        do {
            try coded.write(to: dataModelURL())
        } catch {
            print("Failed to save \(dataFileName) settings: \(error)")
        }
    }
}
