//
//  FavouriteSites.swift
//  Statice
//
//  Created by blance on 2023/4/3.
//

import Foundation

struct FavouriteSite: Codable, Equatable {
    var name: String
    var url: URL
}

class FavouriteSitesSetting: ObservableObject, Codable, DefaultInit {
    @Published var favouriteSites: [FavouriteSite]
    
    func addFavourite(_ favouriteSite: FavouriteSite) {
        objectWillChange.send()
        favouriteSites.append(favouriteSite)
    }
    
    func editFavourite(_ favouriteSite: FavouriteSite, at index: Int) {
        objectWillChange.send()
        if favouriteSites.count - 1 >= index {
            favouriteSites.remove(at: index)
        }
        favouriteSites.insert(favouriteSite, at: index)
    }
    
    required init() { self.favouriteSites = [] }
    init(favouriteSites: [FavouriteSite]) {
        self.favouriteSites = favouriteSites
    }
}
