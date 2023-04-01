//
//  ContentView.swift
//  Statice
//
//  Created by blance on 2023/3/23.
//

import SwiftUI
import WebKit
import Combine

class URLState: ObservableObject {
    @Published var url: URL? = nil
}

import SwiftUI

struct ContentView: View {
    @Namespace private var animationNamespace
    @State var isBrowsingWebsite = false
    @StateObject var urlManager = URLManager()
    @State var isOpenUrl = true
    @State var string = ""
    let text = """
Hello! Test! <br/>
It is a <b>bold</b> test! Happy!(?
"""
    
    var body: some View {
        if (isBrowsingWebsite) {
            BrowserView(animationNamespace: animationNamespace)
        } else {
            WordSearchView(isBrowsingWebsite: $isBrowsingWebsite, animationNamespace: animationNamespace)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView()
        }
    }
}
