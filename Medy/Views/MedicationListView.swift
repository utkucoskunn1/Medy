//
//  MedicationListView.swift
//  Medy
//
//  Created by Utku on 21/07/24.
//

import SwiftUI
import UserNotifications

struct MedicationListView: View {
    @ObservedObject var store: MedicationStore
    @State private var name = ""
    @State private var dosage = ""
    @State private var frequency = ""
    @State private var date = Date()  // Tarih için state ekliyoruz
    @Binding var showAlert: Bool
    @Binding var editing: Bool  // Düzenleme durumu için binding ekliyoruz

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(editing ? "Done" : "Edit") {
                    editing.toggle()
                }
                .padding()
            }

            List {
                ForEach(store.medications, id: \.self) { medication in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(medication.name ?? "Unknown Name")
                            Text(medication.dosage ?? "Unknown Dosage")
                            Text(medication.frequency ?? "Unknown Frequency")
                            Text("\(medication.date ?? Date(), formatter: DateFormatter.short)")
                        }
                        Spacer()
                        Button(action: {
                            store.toggleMedicationTaken(medication: medication)
                        }) {
                            Image(systemName: medication.isTaken ? "checkmark.circle.fill" : "circle")
                        }
                        if editing {
                            Button(action: {
                                store.deleteMedication(medication: medication)
                                showAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Medications")

            TextField("Medication Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Dosage", text: $dosage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Frequency", text: $frequency)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            DatePicker("Select Date and Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                .padding()
            Button(action: {
                store.addMedication(name: name, dosage: dosage, frequency: frequency, isTaken: false, date: date)
                showAlert = true
                scheduleNotification(for: name, at: date)
            }) {
                Text("Add Medication")
            }
            .padding()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(editing ? "Done" : "Edit") {
                    editing.toggle()
                }
            }
        }
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

extension DateFormatter {
    static var short: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

struct MedicationListView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationListView(store: MedicationStore(context: PersistenceController.preview.container.viewContext), showAlert: .constant(false), editing: .constant(false))
    }
}
