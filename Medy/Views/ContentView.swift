//
//  ContentView.swift
//  Medy
//
//  Created by Utku on 21/07/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var medicationStore: MedicationStore
    @StateObject private var appointmentStore: AppointmentStore

    init() {
        let context = PersistenceController.shared.container.viewContext
        _medicationStore = StateObject(wrappedValue: MedicationStore(context: context))
        _appointmentStore = StateObject(wrappedValue: AppointmentStore(context: context))
    }

    @State private var showAlert = false
    @State private var editing = false

    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    HomeView(medicationStore: medicationStore, appointmentStore: appointmentStore)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    MedicationListView(store: medicationStore, showAlert: $showAlert, editing: $editing)
                        .tabItem {
                            Label("Medication", systemImage: "list.bullet")
                        }
                    GetDrugInfoView()
                        .tabItem {
                            Label("AI Assistant", systemImage: "magnifyingglass")
                        }
                    AppointmentListView(store: appointmentStore)
                        .tabItem {
                            Label("Appointment", systemImage: "calendar")
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
