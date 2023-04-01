//
//  WordResultView.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import SwiftUI

struct WordResultView: View {
    let searchResult: [any SearchResult]
    let translationResult: TranslationResult?
    
    var body: some View {
        VStack {
            List {
                translation
                words
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Search")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
    }
    
    var words: some View {
        Section {
            if (searchResult.count != 0) {
                ForEach(searchResult, id: \.id) { result in
                    NavigationLink {
                        result.getView(translationResult)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(result.title)
                            Text(result.excerpt)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Moji")
                                .font(.caption2)
                                .foregroundColor(.secondary.opacity(0.5))
                                .padding(.top, -6)
                        }
                    }
                }
            } else {
                ProgressView()
                    .padding()
                    .frame(maxWidth: .infinity)
            }
        } header: {
            if translationResult != nil {
                Text("Words")
            }
        }
    }
    
    var translation: some View {
        Group {
            if let result = translationResult {
                Section {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("日文")
                                .font(.footnote)
                                .fontWeight(.medium)
                            Text(result.sentence)
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        Divider()
                            .padding(.bottom, 5)
                        Group {
                            if let translation = result.translation {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("中文")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                    Text(translation)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.blue)
                            } else {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                } header: {
                    Text("Translation")
                }
            }
        }
    }
}

struct WordResultView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WordResultView(searchResult: [], translationResult: translationResultTestData)
        }
    }
}
