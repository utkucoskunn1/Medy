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
                if store.medications.isEmpty {
                    VStack {
                        Image(systemName: "pills")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                        Text("No Medications Available")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
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
            }
            .navigationTitle("Medications")

            NavigationLink(destination: AddMedicationView(store: store)) {
                Text("Add Medication")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
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

struct MedicationListView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationListView(store: MedicationStore(context: PersistenceController.preview.container.viewContext), showAlert: .constant(false), editing: .constant(false))
    }
}


