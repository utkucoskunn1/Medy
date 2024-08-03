//
//  AppointmentView.swift
//  Medy
//
//  Created by Utku on 03/08/24.
//

import SwiftUI

struct AddAppointmentView: View {
    @ObservedObject var store: AppointmentStore
    @State private var name = ""
    @State private var date = Date()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Appointment Info")) {
                TextField("Appointment Name", text: $name)
                DatePicker("Select Date and Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
            }
            Button(action: {
                store.addAppointment(name: name, date: date)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Appointment")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarTitle("Add Appointment", displayMode: .inline)
    }
}

struct AddAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        AddAppointmentView(store: AppointmentStore(context: PersistenceController.preview.container.viewContext))
    }
}
