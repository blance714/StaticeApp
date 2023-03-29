//
//  BrowserView.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import SwiftUI

struct BrowserView: View {
    let animationNamespace: Namespace.ID
    
    @StateObject var urlManager = URLManager()
    @StateObject var wordSearchManager = WordSearchManager()
    @State var isSheetPresented = false
    
    
    var body: some View {
        VStack {
            Spacer()
            Text(urlManager.url.absoluteString)
            WebView(url: $urlManager.url, handleSearch: { str in
                isSheetPresented = true
                wordSearchManager.handleSearch(searchText: str)
            })
            Spacer()
            SearchBar(animationNamespace: animationNamespace,
                      handleSubmit: urlManager.handleURLRequest,
                      isBrowsingWebsite: true)
        }
        .popover(isPresented: $isSheetPresented, attachmentAnchor: .point(.center)) {
            NavigationStack {
                WordResultView(searchResult: wordSearchManager.searchResult)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .frame(idealWidth: 400, idealHeight: 650)
        }
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView(animationNamespace: Namespace().wrappedValue)
    }
}
