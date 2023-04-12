//
//  BrowserView.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import SwiftUI
import Combine

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
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in print(value) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    WebView(urlManager: urlManager, handleSearch: { str, sentence in
                        isSearchSheetPresented = true
                        wordSearchManager.handleSearch(searchText: str, sentenceSelection: sentence)
                    }, handleTranslate: { sentence in
                        isTranslationSheetPresented = true
                        wordSearchManager.handleTranslate(sentence: sentence, bold: nil)
                    })
                    if urlManager.isReaderModeEnabled {
                        ReaderModeView(urlManager: urlManager)
                    }
                }
                .animation(.easeInOut, value: urlManager.isReaderModeEnabled)
                URLBar(urlManager: urlManager,
                       handleSubmit: urlManager.handleURLRequest,
                       animationNamespace: animationNamespace)
            }
            .popover(isPresented: $isSearchSheetPresented, attachmentAnchor: .point(.center)) {
                NavigationStack {
                    WordResultView(wordSearchManager: wordSearchManager)
                        .navigationBarTitleDisplayMode(.inline)
                }
                .frame(idealWidth: 400, idealHeight: 650)
            }
            .popover(isPresented: $isTranslationSheetPresented, attachmentAnchor: .point(.center)) {
                TranslationView(translationResult: wordSearchManager.translationResult)
                    .presentationDetents([.medium, .large])
            }
            .background(.background)
        }
    }
}

struct ReaderModeView: View {
    @ObservedObject var urlManager: URLManager
    
    @State var readerData: ReaderData?
    
    var body: some View {
        ScrollView {
            if let readerData = readerData {
                Text(readerData.article)
            } else {
                ProgressView()
                    .onAppear {
                        fetchData()
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
    
    func fetchData() {
        if let convert = urlManager.convertReaderModeData {
            convert().sink { data in
                readerData = data
            }
        }
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView(animationNamespace: Namespace().wrappedValue,
                    urlManager: URLManager(url: URL(string: "https://chen03.github.io/p/color")!))
        .environmentObject(DataModel<FavouriteSitesSetting>(
            dataFileName: "favouriteSitesSetting",
            data: favouriteSitesSettingTestData))
    }
}
