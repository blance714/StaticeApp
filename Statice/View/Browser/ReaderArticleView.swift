//
//  ReaderArticleView.swift
//  Statice
//
//  Created by blance on 2023/5/3.
//

import SwiftUI

func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    
    print(label.frame.height)
    
    return label.frame.height
}

struct ReaderArticleUIView: UIViewRepresentable {
    @Binding var viewHeight: CGFloat
    let article: String
    
    var handleSearch: ((SearchSelection) -> Void)?
    var handleTranslate: ((TranslateSelection) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let uiView = UITextView()
        
        uiView.isEditable = false
        uiView.font = .init(name: "Hiragino Mincho ProN", size: 19)
        uiView.backgroundColor = UIColor.clear
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.isScrollEnabled = false
        uiView.text = article
        
        uiView.delegate = context.coordinator
        
        return uiView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = article
        
        DispatchQueue.main.async {
            let sizeThatFits = uiView.sizeThatFits(CGSize(width: uiView.frame.width, height: .infinity))
            print(sizeThatFits)
            viewHeight = sizeThatFits.height
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: ReaderArticleUIView
        
        init(_ parent: ReaderArticleUIView) {
            self.parent = parent
        }
        
        func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
            let copyElements = suggestedActions.filter{ ($0 as? UIMenu)?.identifier.rawValue == "com.apple.menu.standard-edit" }
            
            let searchAction = UIAction(title: NSLocalizedString("Search", comment: "Search Action")) { action in
                if let view = action.sender as? UITextView,
                   let selectedTextRange = view.selectedTextRange,
                   let selection = view.text(in: selectedTextRange),
                   let handleSearch = self.parent.handleSearch {
                    let rects = view.selectionRects(for: selectedTextRange).map { $0.rect }
                    let sumRect = rects.reduce(rects.first!, { result, value in
                        let minX = min(result.minX, value.minX),
                            minY = min(result.minY, value.minY),
                            maxX = max(result.maxX, value.maxX),
                            maxY = max(result.maxY, value.maxY)
                        
                        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
                    })
                    let text = view.text!,
                        textBefore = text.prefix(view.offset(from: view.beginningOfDocument, to: selectedTextRange.start)),
                        textAfter = text.suffix(text.count - view.offset(from: view.beginningOfDocument, to: selectedTextRange.end))
                    
                    let regexBefore = try? NSRegularExpression(pattern: """
                        (["“【『「](?:『[^"“”【】『』「」\\r\\n]*』|[^"“”【】『』「」\\r\\n])*|([…―—]+)?[^.?!。？！…―—「」\\r\\n]+)$
                        """, options: [])
                    let regexAfter = try? NSRegularExpression(pattern: """
                        ^([^"“”【】『』「」\\r\\n]*["”】』」]|(\\.(?![ .])|[^.?!。？！…―—「」\\r\\n])+([.?!。？！]|[…―—]+)?)
                        """, options: [])
                    
                    let matchesBefore = regexBefore?.matches(in: String(textBefore), options: [], range: NSRange(location: 0, length: textBefore.count))
                    let matchesAfter = regexAfter?.matches(in: String(textAfter), options: [], range: NSRange(location: 0, length: textAfter.count))
                    
                    let sentenceRangeBefore = matchesBefore?.last?.range
                    let sentenceRangeAfter = matchesAfter?.first?.range
                    
                    let sentenceBefore = sentenceRangeBefore != nil ? (textBefore as NSString).substring(with: sentenceRangeBefore!) : ""
                    let sentenceAfter = sentenceRangeAfter != nil ? (textAfter as NSString).substring(with: sentenceRangeAfter!) : ""
                    
//                    let sentenceSelection = SentenceSelec(selected: selection, sentenceBefore: sentenceBefore, sentenceAfter: sentenceAfter)
                        
                    print(matchesBefore?.map{ (textBefore as NSString).substring(with: $0.range) })
                    print(matchesAfter?.map{ (textAfter as NSString).substring(with: $0.range) })
                    print(sentenceBefore)
                    print(sentenceAfter)
//                    print(textAfter)
                    
                    handleSearch(.init(
                        selection: selection,
                        sentence: SentenceSelection(
                            sentence: sentenceBefore + selection + sentenceAfter,
                            bold: "\(sentenceBefore)<b>\(selection)</b>\(sentenceAfter)"),
                        rect: view.convert(sumRect, to: nil)))
                }
            }
            
            let translateAction = UIAction(title: NSLocalizedString("Translate", comment: "Translate Action")) { action in
                if let view = action.sender as? UITextView,
                   let selectedTextRange = view.selectedTextRange,
                   let selection = view.text(in: selectedTextRange),
                   let handleTranslate = self.parent.handleTranslate {
                    let rects = view.selectionRects(for: selectedTextRange).map { $0.rect }
                    let sumRect = rects.reduce(rects.first!, { result, value in
                        let minX = min(result.minX, value.minX),
                            minY = min(result.minY, value.minY),
                            maxX = max(result.maxX, value.maxX),
                            maxY = max(result.maxY, value.maxY)
                   
                        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
                    })
                    handleTranslate(.init(
                        selection: selection,
                        rect: view.convert(sumRect, to: nil)))
                }
            }
            
            let menuElements: [UIMenuElement] = copyElements + [searchAction, translateAction]
            
            return UIMenu(children: menuElements)
        }
    }
}

struct ReaderArticleView: View {
    let article: String
    
    var handleSearch: ((SearchSelection) -> Void)?
    var handleTranslate: ((TranslateSelection) -> Void)?
    
    @State var viewHeight: CGFloat = 500
    var body: some View {
        ScrollView {
            ReaderArticleUIView(viewHeight: $viewHeight, article: article, handleSearch: handleSearch, handleTranslate: handleTranslate)
                .frame(height: viewHeight)
        }
    }
    
}

struct ReaderArticleView_Previews: PreviewProvider {
    
    static var previews: some View {
        ReaderArticleView(article: readerDataTestData.article, handleSearch: { _ in }, handleTranslate: { _ in })
    }
}
