//
//  TextModel.swift
//  Statice
//
//  Created by blance on 2023/3/28.
//

import UIKit
import SwiftUI

let defaultFontSize = UIFont.labelFontSize
let defaultAttributes: [NSAttributedString.Key: Any] =
    [.font: UIFont.systemFont(ofSize: defaultFontSize), .foregroundColor: UIColor.label]

class TextModel: ObservableObject {
    @Published var text = "Hello, how are you?"
    @Published var selectedRange = NSRange()
    
    init() {}
    
    init(string: String) {
        self.load(string: string)
    }
    
    func load(string: String) {
        text = string
    }
    
    func save(to value: Binding<String>) {
        value.wrappedValue = text
    }
    
    func insertText(_ replacement: String) {
        let mutableText = NSMutableString(string: text)
        text.replaceSubrange(Range(selectedRange, in: text)!, with: replacement)
        selectedRange = NSMakeRange(selectedRange.location + text.count, 0)
    }
}
