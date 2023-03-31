//
//  SettingsView.swift
//  Statice
//
//  Created by blance on 2023/3/27.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var ankiDataModel = AnkiDataModel()
    @StateObject var ankiSettingsModel = AnkiSettingsModel()
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
                    
                    FieldsEditor(ankiData: ankiData, ankiSettings: ankiSettingsModel.ankiSettings, dictionary: $dictionary)
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
    
    @Environment(\.scenePhase) private var sceneParse
    @State var isReceivingAnkiData = false
    @State var isConnectingWithAnki = false
    @State var parseError: Error? = nil
    @State var hasParseErrored = false
    
    var body: some View {
        Section {
            Button {
//                if let url = URL(string: "anki://x-callback-url/infoForAdding?x-success=statice://ankiCallback") {
//                    isConnectingWithAnki = true
//                    UIApplication.shared.open(url)
//                }
                ankiData = testData
                ankiSettingsModel.update(with: testData)
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
        .onChange(of: sceneParse) { phase in
            if phase == .active, isReceivingAnkiData,
               let data = UIPasteboard.general.data(forPasteboardType: "net.ankimobile.json") {
                isReceivingAnkiData = false
                isConnectingWithAnki = false
                parseAnkiData(data: data)
            }
        }
        .onOpenURL { url in
            print(url)
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
            print(ankiData)
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
    @ObservedObject var ankiSettings: AnkiSettings
    @Binding var dictionary: Dictionary
    
    var body: some View {
        let fields = (ankiData.notetypes.first(where: { $0.name == ankiSettings.noteType })?.fields.map { $0.name }) ?? []
        
        Section {
            ForEach(fields, id: \.self) { field in
                let binding = ankiSettings.getNoteMapping(dictionary: dictionary.rawValue, field: field)
                    
                NavigationLink {
                    MappingEditor(value: binding, variables: DictionaryFieldVariables[dictionary] ?? [])
                        .navigationTitle(field)
                } label: {
                    Text(field)
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
            SettingsView(ankiDataModel: AnkiDataModel(ankiData: testData))
        }
    }
}

let testData = Statice.AnkiData(decks: [Statice.AnkiData.Deck(name: "core"), Statice.AnkiData.Deck(name: "Physics"), Statice.AnkiData.Deck(name: "カナデ"), Statice.AnkiData.Deck(name: "デフォルト")], notetypes: [Statice.AnkiData.NoteType(name: "Core 2000", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "Optimized-Voc-Index"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-Kanji"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-Furigana"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-Kana"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-English"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-Audio"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-Pos"), Statice.AnkiData.NoteType.Field(name: "Caution"), Statice.AnkiData.NoteType.Field(name: "Expression"), Statice.AnkiData.NoteType.Field(name: "Reading"), Statice.AnkiData.NoteType.Field(name: "Sentence-Kana"), Statice.AnkiData.NoteType.Field(name: "Sentence-English"), Statice.AnkiData.NoteType.Field(name: "Sentence-Clozed"), Statice.AnkiData.NoteType.Field(name: "Sentence-Audio"), Statice.AnkiData.NoteType.Field(name: "Notes"), Statice.AnkiData.NoteType.Field(name: "Core-Index"), Statice.AnkiData.NoteType.Field(name: "Optimized-Sent-Index"), Statice.AnkiData.NoteType.Field(name: "Frequency")]), Statice.AnkiData.NoteType(name: "Physics", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "Front"), Statice.AnkiData.NoteType.Field(name: "Back"), Statice.AnkiData.NoteType.Field(name: "More")]), Statice.AnkiData.NoteType(name: "Saladict Word", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "Date"), Statice.AnkiData.NoteType.Field(name: "Text"), Statice.AnkiData.NoteType.Field(name: "Translation"), Statice.AnkiData.NoteType.Field(name: "Context"), Statice.AnkiData.NoteType.Field(name: "ContextCloze"), Statice.AnkiData.NoteType.Field(name: "Note"), Statice.AnkiData.NoteType.Field(name: "Title"), Statice.AnkiData.NoteType.Field(name: "Url"), Statice.AnkiData.NoteType.Field(name: "Favicon"), Statice.AnkiData.NoteType.Field(name: "Audio")]), Statice.AnkiData.NoteType(name: "单词 RECITE 日语", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "单词"), Statice.AnkiData.NoteType.Field(name: "音标"), Statice.AnkiData.NoteType.Field(name: "释义"), Statice.AnkiData.NoteType.Field(name: "发音"), Statice.AnkiData.NoteType.Field(name: "例句"), Statice.AnkiData.NoteType.Field(name: "例句翻译"), Statice.AnkiData.NoteType.Field(name: "拓展")]), Statice.AnkiData.NoteType(name: "单词 RECITE 日语core", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "单词"), Statice.AnkiData.NoteType.Field(name: "音标"), Statice.AnkiData.NoteType.Field(name: "释义"), Statice.AnkiData.NoteType.Field(name: "发音"), Statice.AnkiData.NoteType.Field(name: "词性"), Statice.AnkiData.NoteType.Field(name: "例句"), Statice.AnkiData.NoteType.Field(name: "例句翻译"), Statice.AnkiData.NoteType.Field(name: "例句发音"), Statice.AnkiData.NoteType.Field(name: "课时"), Statice.AnkiData.NoteType.Field(name: "拓展")]), Statice.AnkiData.NoteType(name: "基本", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "正面"), Statice.AnkiData.NoteType.Field(name: "背面")]), Statice.AnkiData.NoteType(name: "基本型（含翻转的卡片）", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "正面"), Statice.AnkiData.NoteType.Field(name: "背面")]), Statice.AnkiData.NoteType(name: "基本型（输入答案）", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "正面"), Statice.AnkiData.NoteType.Field(name: "背面")]), Statice.AnkiData.NoteType(name: "基本型（随意添加翻转的卡片）", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "正面"), Statice.AnkiData.NoteType.Field(name: "背面"), Statice.AnkiData.NoteType.Field(name: "添加翻转卡片")]), Statice.AnkiData.NoteType(name: "完形填空", kind: "cloze", fields: [Statice.AnkiData.NoteType.Field(name: "文本"), Statice.AnkiData.NoteType.Field(name: "更多")])], profiles: [Statice.AnkiData.Profile(name: "ユーザー 1")])
