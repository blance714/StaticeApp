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
    @State var selectionRect: CGRect = .zero
    
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
                    WebView(urlManager: urlManager, handleSearch: handleSearch(_:), handleTranslate: handleTranslation(_:))
                        .zIndex(1)
                    if urlManager.isReaderModeEnabled {
                        ReaderView(urlManager: urlManager, handleSearch: handleSearch(_:), handleTranslate: handleTranslation(_:))
                            .zIndex(2)
                    }
                    VStack {
                        Color(.systemBackground)
                            .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                            .edgesIgnoringSafeArea(.top)
                        Spacer()
                    }
                    .zIndex(3)
                }
                .animation(.easeInOut, value: urlManager.isReaderModeEnabled)
                .background(ignoresSafeAreaEdges: .top)
                URLBar(urlManager: urlManager,
                       handleSubmit: urlManager.handleURLRequest,
                       animationNamespace: animationNamespace)
            }
            .popover(isPresented: $isSearchSheetPresented,
                     attachmentAnchor: .rect(.rect(selectionRect))) {
                NavigationStack {
                    WordResultView(wordSearchManager: wordSearchManager)
                        .navigationBarTitleDisplayMode(.inline)
                }
                .frame(idealWidth: 400, idealHeight: 650)
                .presentationDetents([.medium, .large])
            }
            .popover(isPresented: $isTranslationSheetPresented, attachmentAnchor: .rect(.rect(selectionRect))) {
            TranslationView(translationResult: wordSearchManager.translationResult)
                .frame(idealWidth: 400, maxHeight: 650)
                .presentationDetents([.medium, .large])
            }
            .background(.background)
        }
    }
    
    func handleSearch(_ selection: SearchSelection) {
        isSearchSheetPresented = true
        selectionRect = selection.rect
        wordSearchManager.handleSearch(searchText: selection.selection, sentenceSelection: selection.sentence)
    }
    
    func handleTranslation(_ selection: TranslateSelection) {
        isTranslationSheetPresented = true
        selectionRect = selection.rect
        wordSearchManager.handleTranslate(sentence: selection.selection, bold: nil)
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
