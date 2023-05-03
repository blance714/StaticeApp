//
//  Reader.swift
//  Statice
//
//  Created by blance on 2023/4/9.
//

import Combine

struct ReaderData {
    var article: String
    var title: String?
    var author: String?
    var series: String?
    var chapter: String?
}

struct ReaderModeConfig {
    var name: String
    var pattern: Regex<Substring>
    var convert: (URLManager) -> AnyPublisher<ReaderData, Error>
}

let ReaderModeConfigList: [ReaderModeConfig] = [
    .init(name: "Pixiv", pattern: /pixiv/, convert: { urlManager in
        Future { promise in
            urlManager.callScript(getPixivDataJS) { result in
                if let json = try? result.get() as? [String: String],
                   let article = json["article"]
                    {
                    print(json)
                    promise(.success(ReaderData(
                        article: article,
                        title: json["title"], author: json["author"], series: json["series"], chapter: json["chapter"]
                    )))
                } else {
                    promise(.failure("Get novel content error."))
                }
            }
        }.eraseToAnyPublisher()
    })
]

let getPixivDataJS = """
let article = document.getElementById('novel-text-container')?.innerText;
  if (!article) {
    article = document.querySelector('.charcoal-token main main')?.innerText;
    let titleElement = document.querySelector('main>section h1'),
      title = titleElement?.innerText,
      seriesText = titleElement.previousElementSibling.children[0]?.innerHTML,
      author = document.querySelectorAll('aside>section>h2 a')[1]?.children[0]?.innerHTML,
      series = seriesText?.split('#')[0]?.trim(),
      chapter = seriesText ? '#' + seriesText.split('#')[1]?.trim() : undefined;
    return {
      article, title, author, series, chapter
    }
  } else {
    let author = document.querySelector('.user-details-name').innerText,
      title = document.querySelector('.title-scroller').innerText,
      series = document.querySelector('.series-badge>.series-title')?.innerText.trim(),
      chapter = document.querySelector('.series-badge>.series-order')?.innerText.trim();

    return {
      article, title, author, series, chapter
    }
  }
"""
