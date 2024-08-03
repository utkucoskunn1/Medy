//
//  SettingsView.swift
//  Medy
//
//  Created by Utku on 03/08/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle(isOn: $themeManager.isDarkMode) {
                    Text("Dark Mode")
                }
            }
            
            Section(header: Text("Notifications")) {
                Toggle(isOn: .constant(true)) {
                    Text("Enable Reminders")
                }
                DatePicker("Reminder Time", selection: .constant(Date()), displayedComponents: .hourAndMinute)
            }
            
            Section(header: Text("Language")) {
                Picker("Language", selection: .constant("English")) {
                    Text("English").tag("English")
                    Text("Turkish").tag("Turkish")
                }
            }
            
            Section(header: Text("Privacy")) {
                Toggle(isOn: .constant(true)) {
                    Text("Share Usage Data")
                }
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("App Version")
                    Spacer()
                    Text("1.0.0")
                }
                HStack {
                    Text("Developer")
                    Spacer()
                    Text("Utku Coşkun")
                }
            }
        }
        .navigationTitle("Settings")
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ThemeManager())
    }
}
