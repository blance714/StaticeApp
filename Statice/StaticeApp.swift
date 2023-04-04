//
//  StaticeApp.swift
//  Statice
//
//  Created by blance on 2023/3/23.
//

import SwiftUI

@main
struct StaticeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AnkiDataModel())
                .environmentObject(AnkiSettingsModel())
                .environmentObject(DataModel<FavouriteSitesSetting>(dataFileName: "favouriteSitesSetting"))
        }
    }
}
