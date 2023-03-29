//
//  TextModel.swift
//  Statice
//
//  Created by blance on 2023/3/28.
//

import UIKit
import SwiftUI

let defaultFontSize = UIFont.labelFontSize

class TextModel: ObservableObject {
    @Published var attributedText: NSAttributedString! = NSAttributedString(string: "This is a test.", attributes: [.font: UIFont.systemFont(ofSize: defaultFontSize), .foregroundColor: UIColor.label])
    @Published var selectedRange = NSRange()
    
    init() {}
    
    init(html: String) {
        let wrappedHtml = "<body style=\"font-family: system-ui; font-size: small;\">\(html)</body>"
        
        attributedText = nil
        NSAttributedString.loadFromHTML(string: wrappedHtml) { text, _, error in
            guard let text = text else { return }
            
            let mutableText = NSMutableAttributedString(attributedString: text)
            mutableText.addAttribute(.foregroundColor, value: UIColor.label, range: NSMakeRange(0, mutableText.length))
            
            self.attributedText = mutableText
        }
    }
    
    func save(to value: Binding<String>) {
        value.wrappedValue = convertToHTMLString(attributedString: attributedText)
    }
    
    func toggleTrait(trait: UIFontDescriptor.SymbolicTraits) {
        if (selectedRange.length == 0) { return }
        
        let selectedAttributedText = attributedText.attributedSubstring(from: selectedRange)
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        
        let font = (selectedAttributedText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont)
        let fontDescriptor = font?.fontDescriptor
        var bold = fontDescriptor?.symbolicTraits.contains(.traitBold) ?? false
        var italic = fontDescriptor?.symbolicTraits.contains(.traitItalic) ?? false
        
        if (trait == .traitBold)    { bold.toggle() }
        if (trait == .traitItalic)  { italic.toggle() }
        
        var symbolicTraits = UIFont.systemFont(ofSize: UIFont.labelFontSize).fontDescriptor.symbolicTraits
        if (bold)   { symbolicTraits.insert(.traitBold) }
        if (italic) { symbolicTraits.insert(.traitItalic) }
        let newFontDescriptor = UIFontDescriptor().withSymbolicTraits(symbolicTraits)!

        let newFont = UIFont(descriptor: newFontDescriptor, size: UIFont.labelFontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: newFont]
        mutableAttributedText.addAttributes(attributes, range: selectedRange)
        
        attributedText = mutableAttributedText
    }
    
    func toggleUnderline() {
        if (selectedRange.length == 0) { return }
        
        let selectedAttributedText = attributedText.attributedSubstring(from: selectedRange)
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        
        var underline = true
        if let attr = attributedText.attribute(.underlineStyle, at: selectedRange.location, effectiveRange: nil) {
            underline = !(attr as? Int == 1)
        }
        mutableAttributedText.addAttribute(.underlineStyle, value: underline ? 1 : 0, range: selectedRange)
        
        attributedText = mutableAttributedText
    }
}
