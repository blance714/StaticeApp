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
    
    var body: some View {
        BrowserView(animationNamespace: animationNamespace)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView()
        }
    }
}
