//
//  mojiTtsFetch.swift
//  Statice
//
//  Created by blance on 2023/4/18.
//

import Foundation
import Combine

struct mojiTtsFetchPostBody: Codable {
    let voiceId = "f000"
    let g_os = "iOS"
    let tarId: String
    let tarType: Int
    
    init(tarId: String, tarType: Int) {
        self.tarId = tarId
        self.tarType = tarType
    }
}

struct mojiTtsFetchResponseBody: Codable {
    let result: Result?
    
    struct Result: Codable {
        let result: Result?
        
        struct Result: Codable {
            let url: String?
        }
    }
}

func mojiTtsFetchPublisher(tarId: String, tarType: Int) -> AnyPublisher<String, Error> {
    let url = URL(string: "https://api.mojidict.com/parse/functions/tts-fetch")!
    var request = URLRequest(url: url)
    request.timeoutInterval = 3
    
    let postBody = mojiTtsFetchPostBody(tarId: tarId, tarType: tarType)
    
    request.httpMethod = "POST"
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("api.mojidict.com", forHTTPHeaderField: "Host")
    request.setValue("E62VyFVLMiW7kvbtVq3p", forHTTPHeaderField: "X-Parse-Application-Id")
    do {
        try request.httpBody = JSONEncoder().encode(postBody)
    } catch let error {
        return Fail(error: error)
            .eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: request)
        .map { response in response.data }
        .decode(type: mojiTtsFetchResponseBody.self, decoder: JSONDecoder())
        .tryMap { data in
            guard let url = data.result?.result?.url else { throw URLError(.badServerResponse) }
            return url
        }
        .eraseToAnyPublisher()
}
