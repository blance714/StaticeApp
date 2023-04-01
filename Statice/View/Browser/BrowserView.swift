//
//  BrowserView.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import SwiftUI

struct BrowserView: View {
    let animationNamespace: Namespace.ID
    
    @StateObject var urlManager: URLManager
    @StateObject var wordSearchManager: WordSearchManager
    @State var isSearchSheetPresented = false
    @State var isTranslationSheetPresented = false
    
    init(animationNamespace: Namespace.ID = Namespace().wrappedValue, urlManager: URLManager = URLManager(), isSheetPresented: Bool = false) {
        self.animationNamespace = animationNamespace
        self._urlManager = StateObject(wrappedValue: urlManager)
        self.isSearchSheetPresented = isSheetPresented
        _wordSearchManager = StateObject(wrappedValue: WordSearchManager())
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(urlManager.url.absoluteString)
            WebView(url: $urlManager.url, handleSearch: { str, sentence in
                isSearchSheetPresented = true
                wordSearchManager.handleSearch(searchText: str, sentenceSelection: sentence)
            }, handleTranslate: { sentence in
                isTranslationSheetPresented = true
                wordSearchManager.handleTranslate(sentence: sentence, bold: nil)
            })
            Spacer()
            SearchBar(animationNamespace: animationNamespace,
                      handleSubmit: urlManager.handleURLRequest,
                      isBrowsingWebsite: true)
        }
        .popover(isPresented: $isSearchSheetPresented, attachmentAnchor: .point(.center)) {
            NavigationStack {
                WordResultView(searchResult: wordSearchManager.searchResult,
                               translationResult: wordSearchManager.translationResult)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .frame(idealWidth: 400, idealHeight: 650)
        }
        .popover(isPresented: $isTranslationSheetPresented, attachmentAnchor: .point(.center)) {
            TranslationView(translationResult: wordSearchManager.translationResult)
                .presentationDetents([.medium, .large])
        }
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView(animationNamespace: Namespace().wrappedValue,
                    urlManager: URLManager(url: URL(string: "https://chen03.github.io/p/color")!))
    }
}
