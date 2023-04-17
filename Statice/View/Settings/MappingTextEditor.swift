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
        textView.backgroundColor = UIColor.init(white: 1, alpha: 0)
        
        textView.delegate = context.coordinator
        textView.inputAccessoryView = context.coordinator.createCustomToolbar(textView)
        
        textView.typingAttributes = [.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)]
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = textModel.text
        uiView.selectedRange = textModel.selectedRange
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MappingTextEditor
        
        init(_ parent: MappingTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.textModel.text = textView.text
            }
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
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
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneAction = UIAction { _ in textView.resignFirstResponder() }
        let doneButton = UIBarButtonItem(systemItem: .done, primaryAction: doneAction)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let variablesMenu = UIMenu(
            title: "Add variables",
            subtitle: "It's a subtitle",
            image: UIImage(systemName: "chevron.left.slash.chevron.right"),
            options: .displayInline,
            children: parent.variables.map{ variable in
                UIAction(title: variable.title,
                         subtitle: "[[\(variable.variable)]]",
                         image: variable.systemImage != nil ? UIImage(systemName: variable.systemImage!) : nil
                ) {
                    _ in self.parent.textModel.insertText("[[\(variable.variable)]]")
                }
            })
        let variablesButton = UIBarButtonItem(title: "Variables", image: UIImage(systemName: "chevron.left.slash.chevron.right"), menu: variablesMenu)
        variablesButton.style = .plain
        
        toolbar.setItems([variablesButton, flexibleSpace, doneButton], animated: true)
        
        return toolbar
    }
}

struct MappingTextEditor_Previews: PreviewProvider {
    @StateObject static var textModel = TextModel()
    
    static var previews: some View {
        MappingTextEditor(textModel: textModel, variables: MojiFieldVariables)
    }
    
}
