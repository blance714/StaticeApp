//
//  TranslationView.swift
//  Statice
//
//  Created by blance on 2023/4/1.
//

import SwiftUI

struct TranslationView: View {
    let translationResult: TranslationResult?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    if let result = translationResult {
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
                                .layoutPriority(1)
                            } else {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
                Text("Youdao Translate")
                    .font(.footnote)
                    .foregroundColor(Color(.tertiaryLabel))
                    .padding(.leading, 18)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .navigationTitle("Translation")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TranslationView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationView(translationResult: translationResultTestData)
    }
}
