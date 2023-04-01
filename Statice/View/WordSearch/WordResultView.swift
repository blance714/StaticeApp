//
//  WordResultView.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import SwiftUI

struct WordResultView: View {
    let searchResult: [any SearchResult]
    
    var body: some View {
        Group {
            if (searchResult.count != 0) {
                List(searchResult, id: \.id) { result in
                    NavigationLink {
                        result.getView()
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
                .scrollContentBackground(.hidden)
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .navigationTitle("Search")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
    }
}

struct WordResultView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WordResultView(searchResult: [MojiSearchResult(id: "198974907", title: "生きる", excerpt: "[自动·二类] 活，生存，保持生命。（命を持ち続ける。） 生活，维持生活，以……为生。（生活する。）")])
        }
    }
}

struct WordResultView2_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MojiSearchResult(id: "198974907", title: "生きる", excerpt: "[自动·二类] 活，生存，保持生命。（命を持ち続ける。） 生活，维持生活，以……为生。（生活する。）").getView()
        }
    }
}
