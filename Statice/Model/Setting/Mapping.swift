//
//  Mapping.swift
//  Statice
//
//  Created by blance on 2023/3/31.
//

import UIKit

struct AnkiFieldVariable {
    let title: String
    let variable: String
    let systemImage: String?
}

let DictionaryFieldVariables: [Dictionary: [AnkiFieldVariable]] = [
    .Moji: MojiFieldVariables
]
