//
//  SearchBar.swift
//  Statice
//
//  Created by blance on 2023/3/26.
//

import SwiftUI

struct SearchBar: View {
    let animationNamespace: Namespace.ID
    let handleSubmit: (String) -> Void
    let isBrowsingWebsite: Bool
    @State var text = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            inputBox
                .padding(.vertical, 8)
                .padding(.horizontal, 18)
                .background(Color(.secondarySystemBackground))
                .matchedGeometryEffect(id: "Bar", in: animationNamespace)
        }
        .matchedGeometryEffect(id: "Stack", in: animationNamespace)
    }
    
    var inputBox: some View {
        textField
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1) ,radius: 8)
    }
    
    var textField: some View {
        TextField(isBrowsingWebsite ? "Enter URL here" : "Enter text here", text: $text)
            .padding(.horizontal)
            .onSubmit {
                handleSubmit(text)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.vertical ,10)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(animationNamespace: Namespace().wrappedValue, handleSubmit: { str in }, isBrowsingWebsite: false)
    }
}
