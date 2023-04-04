//
//  URLBar.swift
//  Statice
//
//  Created by blance on 2023/4/3.
//

import SwiftUI

struct URLBar: View {
    @ObservedObject var urlManager: URLManager
    let handleSubmit: (String) -> Void
    let animationNamespace: Namespace.ID
    
    @Namespace var selfNamespace
    @State var text = ""
    @FocusState var isFocused: Bool
    @State var isInputing = false
    @State var isFavouriteSitesSheetPresented = false
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            inputBox
                .padding(.vertical, 8)
                .padding(.horizontal, 18)
                .background(Color(.secondarySystemBackground))
        }
        .onTapGesture {
            print("233")
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    isFavouriteSitesSheetPresented = true
                } label: { Label("Favourites", systemImage: "bookmark") }
                Spacer()
                Button {
                    urlManager.goBack?()
                } label: { Label("Go back", systemImage: "chevron.backward") }
                    .disabled(!urlManager.canGoBack)
                Button {
                    urlManager.goForward?()
                } label: { Label("Go forward", systemImage: "chevron.forward") }
                    .disabled(!urlManager.canGoForward)
            }
        }
        .popover(isPresented: $isFavouriteSitesSheetPresented) {
            FavouriteSitesView(urlManager: urlManager)
        }
        .onAppear {
            text = urlManager.url.absoluteString
        }
        .onChange(of: urlManager.url) {
            text = $0.absoluteString
        }
    }
    
    var inputBox: some View {
        ZStack(alignment: .bottomLeading) {
            if isInputing {
                textField
            } else {
                urlPanel
            }
            if (urlManager.isLoading) {
                GeometryReader { reader in
                    Rectangle()
                        .frame(width: urlManager.estimatedProgress * reader.size.width)
                        .animation(.spring(), value: urlManager.estimatedProgress)
                }
                .transition(.opacity)
                .frame(height: 2.5)
            }
        }
        .animation(.easeOut, value: urlManager.isLoading)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1) ,radius: 8)
        .matchedGeometryEffect(id: "Bar", in: animationNamespace)
            
    }
    
    var urlPanel: some View {
        HStack (spacing: 0) {
            urlPanelMenu
            Button {
                withAnimation {
                    isInputing = true
                }
            } label: {
                Text(urlManager.url.host ?? "NONE")
                    .matchedGeometryEffect(id: "Text", in: selfNamespace, properties: .position, anchor: UnitPoint(x: 0, y: 0.5))
                    .frame(height: 42)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(.label))
            }
            refreshButton
        }
        .frame(height: 42)
        .frame(maxWidth: .infinity)
    }
    
    var urlPanelMenu: some View {
        Menu {
            Button("233") {}
        } label: {
            Label("Reload", systemImage: "textformat.size")
                .labelStyle(.iconOnly)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1.1, contentMode: .fit)
        .buttonStyle(.plain)
    }
    
    var refreshButton: some View {
        Button {
            if (urlManager.isLoading) {
                urlManager.stopLoading?()
            } else {
                urlManager.reload?()
            }
        } label: {
            if (urlManager.isLoading) {
                Label("Stop", systemImage: "xmark")
                    .labelStyle(.iconOnly)
            } else {
                Label("Reload", systemImage: "arrow.clockwise")
                    .labelStyle(.iconOnly)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1.1, contentMode: .fit)
        .buttonStyle(.plain)
    }
    
    var textField: some View {
        TextField("Enter URL here", text: $text)
            .focused($isFocused)
            .textContentType(.URL)
            .keyboardType(.URL)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
        
            .matchedGeometryEffect(id: "Text", in: selfNamespace, properties: .position, anchor: .leading)
            .padding(.horizontal)
            .padding(.vertical ,10)

            .onChange(of: isFocused) { focused in
                withAnimation {
                    isInputing = focused
                }
            }
            .onSubmit {
                withAnimation {
                    isInputing = false
                }
                isFocused = false
                handleSubmit(text)
            }
            .onAppear {
                isFocused = true
                UITextField.appearance().clearButtonMode = .whileEditing
            }
    }
}

struct URLBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VStack {
                Spacer()
                URLBar(urlManager: urlManagerTestData, handleSubmit: { str in }, animationNamespace: Namespace().wrappedValue)
            }
        }
        .environmentObject(dataModelFavouriteSitesSettingTestData)
    }
}
