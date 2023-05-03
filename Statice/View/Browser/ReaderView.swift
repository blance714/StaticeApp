//
//  ReaderView.swift
//  Statice
//
//  Created by blance on 2023/5/3.
//

import SwiftUI
import Combine

struct ReaderView: View {
    @ObservedObject var urlManager: URLManager
    
    var handleSearch: ((SearchSelection) -> Void)?
    var handleTranslate: ((TranslateSelection) -> Void)?
    
    @State var readerData: ReaderData?
    
    var body: some View {
        VStack {
            if let readerData = readerData {
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            if let series = readerData.series {
                                Text("\(series) \(readerData.chapter ?? "")")
                                    .textSelection(.enabled)
                                    .font(.custom("Hiragino Mincho ProN", size: 16, relativeTo: .callout))
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 5)
                            }
                            if let title = readerData.title {
                                Text(title)
                                    .textSelection(.enabled)
                                    .font(.custom("Hiragino Mincho ProN", size: 28, relativeTo: .title))
                                    .bold()
                                    .padding(.bottom, 5)
                            }
                            if let author = readerData.author {
                                Text(author)
                                    .textSelection(.enabled)
                                    .font(.custom("Hiragino Mincho ProN", size: 16, relativeTo: .callout))
                            }
                            if [readerData.title, readerData.author, readerData.series].contains(where: { $0 != nil }) {
                                Divider()
                                    .padding(.vertical)
                            }
                        }
                        .padding(12)
                        ReaderArticleView(article: readerData.article, handleSearch: handleSearch, handleTranslate: handleTranslate)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                }
            } else {
                ProgressView()
                    .onAppear(perform: fetchData)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
    
    @State var cancellable: AnyCancellable?
    func fetchData() {
        cancellable = urlManager.readerModeDataPublisher()
            .sink { readerData = $0 }
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ReaderView(urlManager: urlManagerTestData, readerData: readerDataTestData)
        }
    }
}
