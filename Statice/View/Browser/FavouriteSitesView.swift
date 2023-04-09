//
//  FavouriteSitesView.swift
//  Statice
//
//  Created by blance on 2023/4/4.
//

import SwiftUI

struct EditingSite: Identifiable {
    let name: String
    let url: URL?
    var id: URL? { url }
}

struct FavouriteSitesView: View {
    @ObservedObject var urlManager: URLManager
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var favouriteSitesSettingModel: DataModel<FavouriteSitesSetting>
    @State private var editMode = EditMode.inactive
    @State var editingSite: EditingSite?
    @State var insertIndex = 0
    
    //    @State var sites = favouriteSitesTestData
    
    var body: some View {
        let sites = favouriteSitesSettingModel.data.favouriteSites
        NavigationStack {
            List($favouriteSitesSettingModel.data.favouriteSites, id: \.url, editActions: .all) { binding in
                let site = binding.wrappedValue
                Button {
                    if !(editMode.isEditing == true) {
                        urlManager.handleURLRequest(urlText: site.url.absoluteString)
                        dismiss()
                    } else {
                        insertIndex = sites.firstIndex(where: { $0 == site }) ?? sites.count
                        editingSite = EditingSite(name: site.name, url: site.url)
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(site.name)
                        Text(site.url.absoluteString)
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                            .lineLimit(2)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        insertIndex = sites.count
                        editingSite = EditingSite(name: urlManager.title ?? "", url: urlManager.url)
                    } label: {
                        Label("Add favourites", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Favourites")
            .environment(\.editMode, $editMode)
            .sheet(item: $editingSite) { site in
                AddFavouriteSitesView(editingSite: site) { name, url in
                    favouriteSitesSettingModel.data.editFavourite(
                        FavouriteSite(name: name, url: url), at: insertIndex)
                }
            }
            .onReceive(favouriteSitesSettingModel.objectWillChange) { _ in
                favouriteSitesSettingModel.save()
            }
        }
    }
}

struct AddFavouriteSitesView: View {
    let editingSite: EditingSite
    @State var nameString: String = ""
    @State var urlString: String = ""
    let saveHandler: ((String, URL) -> Void)
    @State var isAlertPresented = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Name") {
                    TextField("Name", text: $nameString)
                }
                Section("URL") {
                    TextField("URL", text: $urlString)
                        .textContentType(.URL)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("Edit favourite")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if let url = URL(string: urlString) {
                            saveHandler(nameString, url)
                            dismiss()
                        } else {
                            isAlertPresented = true
                        }
                    } label: {
                        Label("Done", systemImage: "checkmark")
                    }
                }
            }
            .alert("Error", isPresented: $isAlertPresented) {
                Text("URL illegal.")
            }
            .onAppear {
                nameString = editingSite.name
                urlString = editingSite.url?.absoluteString ?? ""
            }
        }
    }
}

struct FavouriteSitesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteSitesView(urlManager: URLManager())
            .environmentObject(dataModelFavouriteSitesSettingTestData)
    }
}
