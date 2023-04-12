//
//  Reader.swift
//  Statice
//
//  Created by blance on 2023/4/9.
//

import Combine

struct ReaderData {
    var title: String?
    var author: String?
    var series: String?
    var article: String
}

struct ReaderMode {
    var name: String
    var pattern: Regex<Substring>
    var convert: (URLManager) -> AnyPublisher<ReaderData, Error>
}

let ReaderModeList: [ReaderMode] = [
    .init(name: "Pixiv", pattern: /.*/, convert: { urlManager in
        Future { promise in
            urlManager.callScript("return document.getElementById('novel-text-container').innerText;") { result in
                if let article = try? result.get() as? String {
                    print(article)
                    promise(.success(ReaderData(article: article)))
                } else {
                    promise(.failure("Get novel content error."))
                }
            }
        }.eraseToAnyPublisher()
    })
]
