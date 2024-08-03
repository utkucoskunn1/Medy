//
//  HelpSupportView.swift
//  Medy
//
//  Created by Utku on 03/08/24.
//

import SwiftUI

struct HelpSupportView: View {
    var body: some View {
        Form {
            Section(header: Text("Frequently Asked Questions")) {
                Text("View FAQs")
            }
            
            Section(header: Text("Contact Support")) {
                Text("Submit a Support Request")
                Text("Live Chat")
            }
            
            Section(header: Text("Contact Information")) {
                Text("Email: support@example.com")
                Text("Phone: +1 123 456 7890")
                Text("Follow us on social media")
            }
            
            Section(header: Text("Feedback")) {
                Text("Submit Feedback")
            }
        }
        .navigationTitle("Help & Support")
    }
}

struct HelpSupportView_Previews: PreviewProvider {
    static var previews: some View {
        HelpSupportView()
    }
}
