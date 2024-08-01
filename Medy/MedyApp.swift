//
//  MedyApp.swift
//  Medy
//
//  Created by Utku on 21/07/24.
//

import SwiftUI

@main
struct MedyApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(MedicationStore(context: persistenceController.container.viewContext))
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
