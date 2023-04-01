//
//  WordSearchView.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import SwiftUI

struct WordSearchView: View {
    @Binding var isBrowsingWebsite: Bool
    let animationNamespace: Namespace.ID
    
    @StateObject var wordSearchManager = WordSearchManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0.0) {
                WordResultView(searchResult: wordSearchManager.searchResult, translationResult: nil)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                SearchBar(animationNamespace: animationNamespace, handleSubmit: {str in 
                    wordSearchManager.handleSearch(searchText: str)
                }, isBrowsingWebsite: false)
            }
            .navigationTitle("Search")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        withAnimation {
                            isBrowsingWebsite.toggle()
                        }
                    } label: {
                        Image(systemName: "safari")
                        Text("浏览网页")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        SettingsView()
                            .transition(.slide)
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
        }
        .onAppear {
            wordSearchManager.handleSearch(searchText: "")
        }
    }
}

struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView(isBrowsingWebsite: .constant(false), animationNamespace: Namespace().wrappedValue)
    }
}
