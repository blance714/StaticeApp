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
    
    @EnvironmentObject var favouriteSitesSettingModel: DataModel<FavouriteSitesSetting>
    @Namespace var selfNamespace
    @State var text = ""
    @FocusState var isFocused: Bool
    @State var isInputing = false
    @State var isFavouriteSitesSheetPresented = false
    @State var isSettingSheetPresented = false
    @State var pageFavouriteIndex: Int? = nil
    @State var isMinimized = false
    
    private var sitesSetting: FavouriteSitesSetting {
        favouriteSitesSettingModel.data
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            Group {
                if !isMinimized {
                    inputBox
                        .padding(.vertical, 8)
                        .padding(.horizontal, 18)
                    if !isInputing {
                        toolbarItems
                    }
                }
            }
            .transition(.offset(y: 140))
        }
        .background(Color(.secondarySystemBackground))
        
        .animation(.easeInOut, value: isMinimized)
        .animation(.default, value: urlManager.isLoading)
        
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if isMinimized {
                minimizedView
            }
        }
        .onAppear {
            text = urlManager.url.absoluteString
            pageFavouriteIndex = sitesSetting.favouriteSites.firstIndex(where: { $0.url == urlManager.url })
        }
        .onChange(of: urlManager.url) { url in
            text = url.absoluteString
            pageFavouriteIndex = sitesSetting.favouriteSites.firstIndex(where: { $0.url == url })
        }
        .onChange(of: sitesSetting.favouriteSites) { _ in
            pageFavouriteIndex = sitesSetting.favouriteSites.firstIndex(where: { $0.url == urlManager.url })
            favouriteSitesSettingModel.save()
        }
        .sheet(isPresented: $isSettingSheetPresented) {
            NavigationStack {
                SettingsView()
            }
        }
    }
    
    var toolbarItems: some View {
        HStack(spacing: 20) {
            Group {
                Button {
                    if let index = pageFavouriteIndex {
                        sitesSetting.favouriteSites.remove(at: index)
                    } else {
                        sitesSetting.favouriteSites.append(.init(name: urlManager.title ?? "", url: urlManager.url))
                    }
                } label: {
                    Label("Add favourite",
                          systemImage: pageFavouriteIndex == nil ? "bookmark" : "bookmark.fill")
                    .symbolRenderingMode(.multicolor)
                }
                Button {
                    isFavouriteSitesSheetPresented = true
                } label: { Label("Favourites", systemImage: "book") }
                    .popover(isPresented: $isFavouriteSitesSheetPresented) {
                        FavouriteSitesView(urlManager: urlManager)
                            .frame(idealWidth: 400, idealHeight: 650)
                            .presentationDetents([.medium, .large])
                    }
                Button {
                    isSettingSheetPresented = true
                } label: { Label("Setting", systemImage: "gear") }
                Spacer()
                Button {
                    urlManager.goBack?()
                } label: { Label("Go back", systemImage: "chevron.backward") }
                    .disabled(!urlManager.canGoBack)
                Button {
                    urlManager.goForward?()
                } label: { Label("Go forward", systemImage: "chevron.forward") }
                    .disabled(!urlManager.canGoForward)
                Button {
                    withAnimation {
                        isMinimized = true
                    }
                } label: { Label("Minimize", systemImage: "chevron.down.circle") }
            }
            .font(.title2)
            .fontWeight(.regular)
        }
        .frame(height: 50)
        .padding(.horizontal, 25)
        .labelStyle(.iconOnly)
    }
    
    var loadingProgress: some View {
        Group {
            if urlManager.isLoading {
                GeometryReader { reader in
                    Rectangle()
                        .frame(width: urlManager.estimatedProgress * reader.size.width)
                        .animation(.spring(), value: urlManager.estimatedProgress)
                }
                .frame(height: 2.5)
            }
        }
        .transition(.opacity)
    }
    
    var inputBox: some View {
        ZStack(alignment: .bottomLeading) {
            if isInputing {
                textField
            } else {
                urlPanel
            }
            loadingProgress
                .zIndex(1)
        }
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1) ,radius: 8)
    }
    
    @State var lastTime: Date?
    var urlPanel: some View {
        HStack (spacing: 0) {
            readerButton
            Button {
                withAnimation {
                    isInputing = true
                }
            } label: {
                Text(urlManager.url.host ?? urlManager.url.absoluteString)
                    .frame(height: 42)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(.label))
                    .gesture(DragGesture().onChanged { value in
                        if let lastTime = lastTime {
                            print(sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2)) / (value.time.timeIntervalSince(lastTime)))
                        }
                        lastTime = value.time
                    }.onEnded { value in
                        lastTime = nil
                    })
            }
            refreshButton
        }
        .frame(height: 42)
        .frame(maxWidth: .infinity)
    }
    
    var readerButton: some View {
        Button {
            urlManager.isReaderModeEnabled.toggle()
        } label: {
            Label("Reader",
                  systemImage: urlManager.isReaderModeAvaliable
                    ? "doc.plaintext"
                    : "rectangle.portrait.slash")
                .labelStyle(.iconOnly)
        }
        .disabled(!urlManager.isReaderModeAvaliable)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1.1, contentMode: .fit)
        .buttonStyle(.plain)
        .foregroundColor(urlManager.isReaderModeEnabled ? Color(.systemBackground): Color(.label))
        .background(urlManager.isReaderModeEnabled ? Color(.label): Color.clear)
        .animation(.easeInOut, value: urlManager.isReaderModeEnabled)
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
        
//            .matchedGeometryEffect(id: "Text", in: selfNamespace, properties: .position, anchor: .leading)
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
    
    var minimizedView: some View {
        GeometryReader { reader in
            Text(urlManager.url.host ?? urlManager.url.absoluteString)
                .font(.caption)
                .offset(y: 10)
                .frame(height: reader.safeAreaInsets.bottom, alignment: .top)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .background(alignment: .top) {
                    loadingProgress
                }
                .onTapGesture {
                    withAnimation {
                        isMinimized = false
                    }
                }
        }
        .frame(height: 15)

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
