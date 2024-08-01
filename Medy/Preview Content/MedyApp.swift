//
//  MedyApp.swift
//  Medy
//
//  Created by Utku on 21/07/24.
//

import SwiftUI

@main
struct MedyApp1: App {
    @StateObject private var medicationStore = MedicationStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(medicationStore)
        }
    }
}
