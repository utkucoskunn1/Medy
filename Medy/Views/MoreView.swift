import SwiftUI

struct MoreView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Settings")) {
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                    }
                }
                Section(header: Text("Account")) {
                    NavigationLink(destination: AccountView()) {
                        Text("Account")
                    }
                }
                Section(header: Text("Help & Support")) {
                    NavigationLink(destination: HelpSupportView()) {
                        Text("Help & Support")
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
