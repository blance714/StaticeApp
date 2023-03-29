//
//  NSAttributedString.swift
//  Statice
//
//  Created by blance on 2023/3/29.
//

import Foundation
import UIKit

extension NSAttributedString {
    public func isHTMLEqual(to other: NSAttributedString) -> Bool {
        if !self.isEqual(to: other) {
            return convertToHTMLString(attributedString: self) == convertToHTMLString(attributedString: other)
        }
        return true
    }
}

func convertToHTMLString(attributedString: NSAttributedString) -> String {
    let htmlTagReplacements: [NSAttributedString.Key: (open: String, close: String)] = [
        .underlineStyle: ("<u>", "</u>"),
        .strikethroughStyle: ("<strike>", "</strike>")
    ]
    
    var htmlString = ""
    
    attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.length), options: []) { attributes, range, _ in
        var taggedString = attributedString.attributedSubstring(from: range).string
        
        for (attributeKey, tags) in htmlTagReplacements {
            if let _ = attributes[attributeKey] {
                taggedString = "\(tags.open)\(taggedString)\(tags.close)"
            }
        }
        
        if let font = attributes[.font] as? UIFont {
            let traits = font.fontDescriptor.symbolicTraits
            if (traits.contains(.traitBold)) {
                taggedString = "<b>\(taggedString)</b>"
            }
            if (traits.contains(.traitItalic)) {
                taggedString = "<i>\(taggedString)</i>"
            }
        }
        
        htmlString += taggedString
    }
    
    htmlString.replace(try! Regex("\\n"), with: "<br/>")
    return htmlString
}

//func createImageWithPinkBoxAndText(text: String) -> UIImage {
//    let imageSize = CGSize(width: 300, height: 300)
//    let renderer = UIGraphicsImageRenderer(size: imageSize)
//
//    let image = renderer.image { (context) in
//        let rectangle = CGRect(x: 10, y: 10, width: imageSize.width - 20, height: imageSize.height - 20)
//        let pinkColor = UIColor(red: 1, green: 192/255, blue: 203/255, alpha: 1)
//        pinkColor.setFill()
//        context.cgContext.fill(rectangle)
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//
//        let textAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(ofSize: 24),
//            .foregroundColor: UIColor.black,
//            .paragraphStyle: paragraphStyle
//        ]
//
//        let textSize = text.size(withAttributes: textAttributes)
//        let textRect = CGRect(x: (imageSize.width - textSize.width) / 2,
//                              y: (imageSize.height - textSize.height) / 2,
//                              width: textSize.width,
//                              height: textSize.height)
//
//        text.draw(in: textRect, withAttributes: textAttributes)
//    }
//
//    return image
//}
