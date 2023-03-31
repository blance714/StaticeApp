//
//  MappingEditor.swift
//  Statice
//
//  Created by blance on 2023/3/28.
//

import SwiftUI
import Foundation

struct MappingTextEditor: UIViewRepresentable {
    @ObservedObject var textModel: TextModel
    let variables: [AnkiFieldVariable]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        print(variables)
        
        textView.backgroundColor = UIColor.init(white: 1, alpha: 0)
        
        textView.delegate = context.coordinator
        textView.inputAccessoryView = context.coordinator.createCustomToolbar(textView)
        
        textView.typingAttributes = [.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)]
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        print("updateUIView equal: \(uiView.attributedText.isHTMLEqual(to: textModel.attributedText))")
        if !uiView.attributedText.isHTMLEqual(to: textModel.attributedText) {
            uiView.attributedText = textModel.attributedText
        }
        uiView.selectedRange = textModel.selectedRange
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MappingTextEditor
        
        init(_ parent: MappingTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            print("textViewDidChange")
            DispatchQueue.main.async {
                self.parent.textModel.attributedText = textView.attributedText
            }
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            print("textViewDidChangeSelection: \(textView.selectedRange)")
            DispatchQueue.main.async {
                self.parent.textModel.selectedRange = textView.selectedRange
            }
        }
        
        

        func printHTML(in textView: UITextView) {
            print(convertToHTMLString(attributedString: textView.attributedText))
        }
    }
}

extension MappingTextEditor.Coordinator {
    /// Create keyboard toolbar
    func createCustomToolbar(_ textView: UITextView) -> UIToolbar {
        
        print(parent.variables)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneAction = UIAction { _ in textView.resignFirstResponder() }
        let doneButton = UIBarButtonItem(systemItem: .done, primaryAction: doneAction)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        
        let boldAction = UIAction(
            title: "Bold",
            image: UIImage(systemName: "bold")) { _ in self.parent.textModel.toggleTrait(trait: .traitBold) }
        let italicAction = UIAction(
            title: "Italic",
            image: UIImage(systemName: "italic")) { _ in self.parent.textModel.toggleTrait(trait: .traitItalic) }
        let underlineAction = UIAction(
            title: "Underline",
            image: UIImage(systemName: "underline")) { _ in self.parent.textModel.toggleUnderline() }
        
//        let attrMenu = UIMenu(
//            title: "Set Attribute",
//            image: UIImage(systemName: "bold.italic.underline"),
//            options: .displayInline,
//            children: [boldAction, italicAction, underlineAction])
//        let attrButton = UIBarButtonItem(title: "Set Attributes", image: UIImage(systemName: "bold.italic.underline"), menu: attrMenu)
        
        let variablesMenu = UIMenu(
            title: "Add variables",
            subtitle: "It's a subtitle",
            image: UIImage(systemName: "chevron.left.slash.chevron.right"),
            options: .displayInline,
            children: parent.variables.map{ variable in
                UIAction(title: variable.title,
                         subtitle: "[[\(variable.variable)]]",
                         image: variable.image
                ) {
                    _ in print(variable.title)
                }
            })
        let variablesButton = UIBarButtonItem(title: "Variables", image: UIImage(systemName: "chevron.left.slash.chevron.right"), menu: variablesMenu)
        variablesButton.style = .plain
        
        let boldButton = UIBarButtonItem(primaryAction: boldAction)
        let italicButton = UIBarButtonItem(primaryAction: italicAction)
        let underlineButton = UIBarButtonItem(primaryAction: underlineAction)
        
        toolbar.setItems([boldButton, italicButton, underlineButton, variablesButton, flexibleSpace, doneButton], animated: false)
        
        return toolbar
    }
    
    /// Add custom edit menu element.
    func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        var additionalActions: [UIMenuElement] = []
        if range.length > 0 {
            let boldAction = UIAction(title: "Bold", image: UIImage(systemName: "highlighter")) { action in
                self.parent.textModel.toggleTrait(trait: .traitBold)
            }
            additionalActions.append(boldAction)
        }
        
        let printAction = UIAction(title: "Print", image: UIImage(systemName: "heart")) { action in
            self.printHTML(in: textView)
        }
        additionalActions.append(printAction)
        
        return UIMenu(children: additionalActions + suggestedActions)
    }
}

struct MappingTextEditor_Previews: PreviewProvider {
    @StateObject static var textModel = TextModel()
//    @State static var text = NSAttributedString(string: "Just a test.", attributes: [.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)])
//    @State static var range = NSRange()
    
    
    static var previews: some View {
        MappingTextEditor(textModel: textModel, variables: MojiFieldVariables)
    }
    
}
