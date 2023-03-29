//
//  MappingEditor.swift
//  Statice
//
//  Created by blance on 2023/3/28.
//

import SwiftUI

struct MappingEditor: View {
    @Binding var value: String
    @StateObject var textModel: TextModel
    @State var bold = false
    
    init(value: Binding<String>) {
        _value = value
        _textModel = StateObject(wrappedValue: TextModel(html: value.wrappedValue))
    }
    
    var body: some View {
        Group {
            if (textModel.attributedText != nil) {
                MappingTextEditor(textModel: textModel)
//                TextEditor(text: $value)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .onDisappear {
                        textModel.save(to: $value)
                    }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

struct MappingEditor_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var code: String = "Text <b>field</b>!"
        
        var body: some View{
            NavigationStack {
                VStack {
                    Text(code)
                    MappingEditor(value: $code)
                }
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
