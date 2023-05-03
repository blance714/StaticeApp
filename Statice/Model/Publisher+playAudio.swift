//
//  Publisher+playAudio.swift
//  Statice
//
//  Created by blance on 2023/5/2.
//

import Foundation
import Combine
import AVKit

extension Publisher {
    func getData() -> AnyPublisher<Data, Error> where Output == String, Failure == Error {
        self.flatMap { urlString -> AnyPublisher<Data, Error> in
            guard let url = URL(string: urlString) else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            return URLSession.shared.dataTaskPublisher(for: url)
                .mapError { $0 as Error }
                .map { (data, _) in data }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
