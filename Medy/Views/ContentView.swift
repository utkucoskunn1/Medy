//
//  ContentView.swift
//  Medy
//
//  Created by Utku on 21/07/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var store: MedicationStore

    init() {
        let context = PersistenceController.shared.container.viewContext
        _store = StateObject(wrappedValue: MedicationStore(context: context))
    }

    @State private var showAlert = false
    @State private var editing = false

    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    HomeView(store: store)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    MedicationListView(store: store, showAlert: $showAlert, editing: $editing)
                        .tabItem {
                            Label("Medication List", systemImage: "list.bullet")
                        }
                    GetDrugInfoView()
                        .tabItem {
                            Label("Get Drug Info", systemImage: "magnifyingglass")
                        }
                    MoreView()
                        .tabItem {
                            Label("More", systemImage: "ellipsis")
                        }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Success"), message: Text("Successfully added or deleted!"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ThemeManager()) // Add this line to preview the theme manager
    }
}
