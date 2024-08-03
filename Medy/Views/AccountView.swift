//
//  AccountView.swift
//  Medy
//
//  Created by Utku on 03/08/24.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                Text("Username: johndoe")
                Text("Email: johndoe@example.com")
                Button("Change Profile Picture") {
                    // Profile picture change action
                }
            }
            
            Section(header: Text("Password")) {
                Button("Change Password") {
                    // Change password action
                }
                Button("Reset Password") {
                    // Reset password action
                }
            }
            
            Section(header: Text("Security")) {
                Toggle(isOn: .constant(true)) {
                    Text("Two-Factor Authentication")
                }
            }
            
            Section(header: Text("Data Management")) {
                Button("Export Data") {
                    // Export data action
                }
                Button("Delete Account") {
                    // Delete account action
                }
            }
            
            Section(header: Text("Subscription")) {
                Text("Plan: Premium")
                Text("Next Billing Date: 2024-09-01")
            }
            
            Section(header: Text("Session Management")) {
                Button("Manage Active Sessions") {
                    // Manage active sessions action
                }
                Button("Logout") {
                    // Logout action
                }
            }
        }
        .navigationTitle("Account")
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
