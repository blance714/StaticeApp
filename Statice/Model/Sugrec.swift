//
//  Sugrec.swift
//  Statice
//
//  Created by blance on 2023/3/23.
//

import Foundation

struct SearchOption: Codable {
    var type: String
    var sa: String
    var q: String
}

struct Sugrec: Codable {
    var q: String
    var p: Bool
    var g: [SearchOption]
    var slid: String
    var queryid: String
}

struct SearchOptionID: Identifiable {
    var id: String
}
