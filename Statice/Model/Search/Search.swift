//
//  Search.swift
//  Statice
//
//  Created by blance on 2023/3/30.
//

import Foundation
import SwiftUI

enum Dictionary: String, CaseIterable {
    case Moji
}

struct SearchResult: Identifiable, Hashable {
    let id: String
    let title: String
    let excerpt: String
    let dictionary: Dictionary
}

struct SearchResultView: View {
    let searchResult: SearchResult
    
    var body: some View {
        switch searchResult.dictionary {
        case .Moji: MojiResultView(searchResult: searchResult)
        }
    }
}
