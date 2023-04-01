//
//  CustomWKWebkit.swift
//  Statice
//
//  Created by blance on 2023/3/24.
//

import Foundation
import WebKit
import SwiftUI
import Combine

class CustomWKWebView: WKWebView {
    var handleSearch: ((String, SentenceSelection) -> Void)?
    var handleTranslate: ((String) -> Void)?
    
    init(handleSearch: ((String, SentenceSelection) -> Void)?, handleTranslate: ((String) -> Void)?) {
        self.handleSearch = handleSearch
        self.handleTranslate = handleTranslate
        
        let configuration = WKWebViewConfiguration()
        super.init(frame: .zero, configuration: configuration)
        setupCustomMenu() 
        print("init wk")
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setupCustomMenu()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomWKWebView {
    private func setupCustomMenu() {
        let searchWordMenuItem = UIMenuItem(title: "Search", action: #selector(searchWordAction(_:)))
        let translateMenuItem = UIMenuItem(title: "Translate", action: #selector(translateAction(_:)))
        UIMenuController.shared.menuItems = [searchWordMenuItem, translateMenuItem]
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print(action)
        print(sender)
        if action == #selector(copy(_:)) || action == #selector(searchWordAction(_:)) || action == #selector(translateAction(_:)) {
            return true
        }
        return false
    }
    
    @objc func translateAction(_ sender: Any?) {
        print("Translate Action")
        evaluateJavaScript("window.getSelection().toString()") { (result, error) in
            if let text = result as? String {
                self.handleTranslate?(text)
            } else if let error = error {
                print("获取选中文本时出错：\(error)")
            }
        }
    }
    
    @objc func searchWordAction(_ sender: Any?) {
        // 在这里执行你的自定义操作
        print("Search Action")
        evaluateJavaScript(getSelectionJS) {(result, error) in
            if let data = (result as? String)?.data(using: .utf8),
               let selection = try? JSONDecoder().decode(GetSelectionReturnValue.self, from: data)
            {
                self.handleSearch?(
                    selection.selection,
                    SentenceSelection(sentence: selection.sentence, bold: selection.bold))
            } else {
                print("Failed to get selection: \(error)")
            }
        }
//        evaluateJavaScript("window.getSelection().toString()") { (result, error) in
//            if let text = result as? String {
//                self.handleSearch?(text)
//            } else if let error = error {
//                print("获取选中文本时出错：\(error)")
//            }
//        }
    }
}

struct GetSelectionReturnValue: Codable {
    let sentence: String
    let bold: String
    let selection: String
}

struct SentenceSelection: Codable {
    let sentence: String
    let bold: String
}

let getSelectionJS = """
(() => {
  const INLINE_TAGS = new Set([
    // Inline text semantics
    'a', 'abbr', 'b', 'bdi', 'bdo', 'br', 'cite', 'code', 'data', 'dfn', 'em', 'i',
    'kbd', 'mark', 'q', 'rp', 'rt', 'rtc', 'ruby', 's', 'samp', 'small',
    'span', 'strong', 'sub', 'sup', 'time', 'u', 'var', 'wbr'
  ])
  const sentenceHeadTester = /(["“【『「](?:『[^"“”【】『』「」\\r\\n]*』|[^"“”【】『』「」\\r\\n])*|([…―—]+)?[^.?!。？！…―—「」\\r\\n]+)$/
  const sentenceTailTester = /^([^"“”【】『』「」\\r\\n]*["”】』」]|(\\.(?![ .])|[^.?!。？！…―—「」\\r\\n])+([.?!。？！]|[…―—]+)?)/

  let selection = window.getSelection()
  const selectedText = selection.toString()
  if (!selectedText.trim()) { return JSON.stringify({sentence: null, bold: null}) }

  var sentenceHead = ''
  var sentenceTail = ''

  const range = selection.getRangeAt(0);
  const anchorNode = range.startContainer;
  if (
      anchorNode
          ?.nodeType === Node.TEXT_NODE
  ) {
      let leadingText = anchorNode.textContent?.slice(0, range.startOffset) ?? '';
      for (let node = anchorNode.previousSibling; node; node = node.previousSibling) {
          if (node.nodeType === Node.TEXT_NODE) {
              leadingText = node.textContent + leadingText;
          } else if (node.nodeType === Node.ELEMENT_NODE) {
              leadingText = node.innerText + leadingText
          }
      }

      for (
          let element = anchorNode.parentElement;
          element && INLINE_TAGS.has(element.tagName.toLowerCase()) && element !== document.body;
          element = element.parentElement
      ) {
          for (let el = element.previousElementSibling; el; el = el.previousElementSibling) {
              leadingText = el.innerText + leadingText;
          }
      }

      sentenceHead = (leadingText.match(sentenceHeadTester) || [''])[0];
  }

  const focusNode = range.endContainer;
  if (
      focusNode
          ?.nodeType === Node.TEXT_NODE
  ) {
      let tailingText = focusNode.textContent?.slice(range.endOffset) ?? '';
      for (let node = focusNode.nextSibling; node; node = node.nextSibling) {
          if (node.nodeType === Node.TEXT_NODE) {
              tailingText += node.textContent;
          } else if (node.nodeType === Node.ELEMENT_NODE) {
              tailingText += node.innerText
          }
      }

      for (
          let element = focusNode.parentElement;
          element && INLINE_TAGS.has(element.tagName.toLowerCase()) && element !== document.body;
          element = element.parentElement
      ) {
          for (let el = element.nextElementSibling; el; el = el.nextElementSibling) {
              tailingText += el.innerText
          }
      }

      sentenceTail = (tailingText.match(sentenceTailTester) || [''])[0]
  }

  return JSON.stringify({
    sentence: (sentenceHead + selectedText + sentenceTail)
      .replace(/(^\\s+)|(\\s+$)/gm,'\\n')
      .replace(/(^\\s+)|(\\s+$)/g, ''),
    bold: (sentenceHead + '<b>' + selectedText + '</b>' + sentenceTail)
    .replace(/(^\\s+)|(\\s+$)/gm,'\\n')
    .replace(/(^\\s+)|(\\s+$)/g, ''),
    selection: selection.toString()
  })
})()
"""
