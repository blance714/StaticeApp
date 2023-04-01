//
//  AddNoteView.swift
//  Statice
//
//  Created by blance on 2023/4/1.
//

import SwiftUI
import Combine

struct AddNoteView: View {
    let converter: AnkiFieldVariableConverter
    let dictionary: Dictionary
    
    @EnvironmentObject private var ankiDataModel: AnkiDataModel
    @EnvironmentObject private var ankiSettingsModel: AnkiSettingsModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var fieldsValue: [String: String] = [:]
    @State private var isAddingNote = false
    @State private var willEnterForegroundSubscriber: AnyCancellable?
    
    var body: some View {
        NavigationStack {
            Group {
                if let ankiData = ankiDataModel.ankiData {
                    let noteTypeName = ankiSettingsModel.ankiSettings.noteType
                    if let noteType = ankiData.notetypes.first(where: { $0.name == noteTypeName }) {
                        List(noteType.fields, id: \.name) { field in
                            Section {
                                let binding = Binding {
                                    fieldsValue[field.name] ?? ""
                                } set: { newValue in
                                    fieldsValue[field.name] = newValue
                                }
                                TextEditor(text: binding)
                                    .onAppear {
                                        loadField(fieldName: field.name)
                                    }
                            } header: {
                                Text(field.name)
                            }
                        }
                    } else {
                        VStack {
                            Text("No corresponding note type.")
                            Text("Please check your Anki settings.")
                        }
                    }
                } else {
                    VStack {
                        Text("No Anki data.")
                        Text("Please fetch Anki datas in setting.")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if (isAddingNote) {
                        ProgressView()
                    } else {
                        Button {
                            addNotetoAnki()
                            isAddingNote = true
                        } label: {
                            Label("Done", systemImage: "checkmark")
                        }
                    }
                }
                ToolbarItem(placement: .status) {
                    Toggle(isOn: $ankiSettingsModel.ankiSettings.allowAddingSameNote) {
                        Label("Allow duplicating", systemImage: "plus.square.on.square")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
        .navigationTitle("Add Note to Anki")
        }
        .onAppear {
            willEnterForegroundSubscriber = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
                .sink { _ in
                    if isAddingNote {
                        isAddingNote = false
                    }
                }
        }
        .onDisappear {
            willEnterForegroundSubscriber?.cancel()
            willEnterForegroundSubscriber = nil
        }
        .onOpenURL { url in
            if url.absoluteString == "statice://ankiCallback?type=addNote" {
                dismiss()
            }
        }
    }
    
    func loadField(fieldName: String) {
        let input = ankiSettingsModel.ankiSettings.getNoteMapping(dictionary: dictionary.rawValue, field: fieldName).wrappedValue
        var output = input
        
        let regexPattern = "(\\[\\[(.*?)]])"
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        
        let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.count))
        
        for match in matches.reversed() {
            //                                    print(input[Range(match.range(at: 1), in: output)!])
            if let range = Range(match.range(at: 2), in: input) {
                let key = String(input[range])
                let value = converter.convert(key)
                if let fullRange = Range(match.range(at: 1), in: output) {
                    output.replaceSubrange(fullRange, with: value)
                }
            }
        }
        
        fieldsValue[fieldName] = output
    }
    
    func addNotetoAnki() {
        let settings = ankiSettingsModel.ankiSettings
        var url = URL(string: "anki://x-callback-url/addnote")!
        var query = [
            URLQueryItem(name: "type", value: settings.noteType),
            URLQueryItem(name: "deck", value: settings.deck)
        ]
        
        for field in fieldsValue {
            if field.value == "" { continue }
            query.append(.init(name: "fld" + field.key, value: field.value))
        }
        
        if settings.allowAddingSameNote {
            query.append(.init(name: "dupes", value: "1"))
        }
        query.append(.init(name: "x-success", value: "statice://ankiCallback?type=addNote"))
        
        url.append(queryItems: query)
        
        UIApplication.shared.open(url)
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddNoteView(converter: MojiFieldVariableConverter(map: mapMojiConverterTestData), dictionary: .Moji)
        }
        .environmentObject(AnkiDataModel(ankiData: ankiDataTestData))
        .environmentObject(AnkiSettingsModel(ankiSettings: ankiSettingsTestData))
    }
}
