//
//  AddMedicationView.swift
//  Medy
//
//  Created by Utku on 03/08/24.
//

import SwiftUI

struct AddMedicationView: View {
    @ObservedObject var store: MedicationStore
    @State private var name = ""
    @State private var dosage = ""
    @State private var frequency = ""
    @State private var date = Date()  // Tarih için state ekliyoruz
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Medication Info")) {
                TextField("Medication Name", text: $name)
                TextField("Dosage", text: $dosage)
                TextField("Frequency", text: $frequency)
                DatePicker("Select Date and Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
            }
            Button(action: {
                store.addMedication(name: name, dosage: dosage, frequency: frequency, isTaken: false, date: date)
                scheduleNotification(for: name, at: date)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Medication")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarTitle("Add Medication", displayMode: .inline)
        
    }

    // Bildirim planlama fonksiyonu
    func scheduleNotification(for name: String, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "It's time to take your medication: \(name)"
        content.sound = UNNotificationSound.default

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

struct AddMedicationView_Previews: PreviewProvider {
    static var previews: some View {
        AddMedicationView(store: MedicationStore(context: PersistenceController.preview.container.viewContext))
            .environmentObject(ThemeManager())
    }
}
