//
//  SettingsView.swift
//  Statice
//
//  Created by blance on 2023/3/27.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var ankiDataModel: AnkiDataModel
    @EnvironmentObject var ankiSettingsModel: AnkiSettingsModel
    @State var dictionary: Dictionary = .Moji
    
    var body: some View {
        List {
            ConnectWithAnkiButton(ankiData: $ankiDataModel.ankiData, ankiSettingsModel: ankiSettingsModel)
            if let ankiData = ankiDataModel.ankiData {
                Group {
                    Picker("Deck", selection: $ankiSettingsModel.ankiSettings.deck) {
                        ForEach(ankiData.decks, id: \.name) { deck in
                            Text(deck.name).tag(deck.name)
                        }
                    }
                    Picker("Note Type", selection: $ankiSettingsModel.ankiSettings.noteType) {
                        ForEach(ankiData.notetypes, id: \.name) { note in
                            Text(note.name).tag(note.name)
                        }
                    }
                    
                    Section {
                        Picker("Dictionary", selection: $dictionary) {
                            ForEach(Dictionary.allCases, id: \.self) { dictionary in
                                Text(dictionary.rawValue)
                            }
                        }
                    } header: {
                        Text("Mapping")
                    } footer: {
                        Text("Choose a dictionary to map.")
                    }
                    
                    FieldsEditor(ankiData: ankiData, ankiSettings: $ankiSettingsModel.ankiSettings, dictionary: $dictionary)
                }
                .pickerStyle(.navigationLink)
                .onDisappear {
                    ankiDataModel.save()
                    ankiSettingsModel.save()
                }
            }
        }
        .navigationTitle("Anki")
    }
}

struct ConnectWithAnkiButton: View {
    @Binding var ankiData: AnkiData?
    @ObservedObject var ankiSettingsModel: AnkiSettingsModel
    
    @Environment(\.scenePhase) private var scenePhase
    @State var isReceivingAnkiData = false
    @State var isConnectingWithAnki = false
    @State var parseError: Error? = nil
    @State var hasParseErrored = false
    
    var body: some View {
        Section {
            Button {
                if let url = URL(string: "anki://x-callback-url/infoForAdding?x-success=statice://ankiCallback") {
                    isConnectingWithAnki = true
                    UIApplication.shared.open(url)
                }
//                ankiData = ankiDataTestData
//                ankiSettingsModel.update(with: ankiDataTestData)
            } label: {
                HStack {
                    if (ankiData != nil) {
                        Label("Refresh Anki data", systemImage: "arrow.clockwise")
                    } else {
                        Label("Connect with Anki", systemImage: "link")
                    }
                    Spacer()
                    if isConnectingWithAnki {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
            }
        } footer: {
            Text("Get profiles from Anki app.")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.didActivateNotification)) { _ in
            if isReceivingAnkiData,
               let data = UIPasteboard.general.data(forPasteboardType: "net.ankimobile.json") {
                isReceivingAnkiData = false
                isConnectingWithAnki = false
                parseAnkiData(data: data)
            }
        }
        .onOpenURL { url in
            print("onOpenURL: \(url)")
            if (url.absoluteString == "statice://ankiCallback") {
                isReceivingAnkiData = true
            }
        }
        .alert("Decoding Error", isPresented: $hasParseErrored) {
            Text("Dismiss")
        } message: {
            Text(parseError?.localizedDescription ?? "")
        }
    }
    
    func parseAnkiData(data: Data) {
        do {
            let yetData = try JSONDecoder().decode(AnkiData.self, from: data)
            print("parseAnkiData\(ankiData)")
            DispatchQueue.main.async {
                withAnimation() {
                    ankiData = yetData
                    ankiSettingsModel.update(with: yetData)
                }
            }
        } catch let error {
            parseError = error
            hasParseErrored = true
        }
    }
}

struct FieldsEditor: View {
    let ankiData: AnkiData
    @Binding var ankiSettings: AnkiSettings
    @Binding var dictionary: Dictionary
    
    var body: some View {
        let fields = (ankiData.notetypes.first(where: { $0.name == ankiSettings.noteType })?.fields) ?? []
        
        Section {
            ForEach(fields, id: \.self) { field in
                NavigationLink(field.name) {
                    let binding = ankiSettings.getNoteMapping(dictionary: dictionary.rawValue, field: field.name)
                    let variables = DictionaryFieldVariables[dictionary] ?? []
                    MappingEditor(value: binding, variables: variables)
                        .navigationTitle(field.name)
                }
            }
        } header: {
            Text("Fields to map")
        } footer: {
            Text("Choose a field to edit the mapping content.")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(AnkiDataModel(ankiData: ankiDataTestData))
                .environmentObject(AnkiSettingsModel(ankiSettings: ankiSettingsTestData))
        }
    }
}
