//
//  MoreView.swift
//  Medy
//
//  Created by Utku on 21/07/24.
//

import SwiftUI

struct MoreView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Settings")) {
                    Toggle(isOn: $themeManager.isDarkMode) {
                        Text("Dark Mode")
                    }
                }
            }
            .navigationTitle("More")
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ThemeManager()) // Add this line to preview the theme manager
    }
}
