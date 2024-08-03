import SwiftUI

struct HomeView: View {
    @ObservedObject var medicationStore: MedicationStore
    @ObservedObject var appointmentStore: AppointmentStore
    @State private var patientName: String = "John Doe"
    @State private var selectedDate: Date = Date()
    @State private var showAddMedicationView = false
    @State private var showAddAppointmentView = false
    @State private var editing = false

    var body: some View {
        VStack {
            // Top section: Date and Patient Name
            HStack {
                Text("Welcome: ")
                    .padding()
                    .font(.headline)
                
                Spacer()
                
                Text(patientName)
                    .font(.headline)
                    .padding()
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }

            // Middle sections
            VStack(spacing: 10) {
                // Medications section
                HStack {
                    Text("💊  Medications")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        showAddMedicationView = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .sheet(isPresented: $showAddMedicationView) {
                        AddMedicationView(store: medicationStore)
                    }
                }
                .padding([.leading, .trailing, .top])

                List {
                    ForEach(medicationStore.medications, id: \.self) { medication in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(medication.name ?? "Unknown Medication")
                                    .font(.headline)
                                Text("Dosage: \(medication.dosage ?? "Unknown Dosage")")
                                Text("Frequency: \(medication.frequency ?? "Unknown Frequency")")
                            }
                            Spacer()
                            Button(action: {
                                medicationStore.toggleMedicationTaken(medication: medication)
                            }) {
                                Image(systemName: medication.isTaken ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(medication.isTaken ? .green : .gray)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: 200)

                // Appointments section
                HStack {
                    Text("🗓️  Appointments")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        showAddAppointmentView = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .sheet(isPresented: $showAddAppointmentView) {
                        AddAppointmentView(store: appointmentStore)
                    }
                }
                .padding([.leading, .trailing, .top])

                if appointmentStore.appointments.isEmpty {
                    Text("No appointments today")
                } else {
                    List {
                        ForEach(appointmentStore.appointments, id: \.self) { appointment in
                            Text(appointment.name ?? "Unknown Appointment")
                        }
                    }
                }
            }
            .padding()

            Spacer()
        }
        .onAppear {
            medicationStore.fetchData(for: selectedDate)
         
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(medicationStore: MedicationStore(context: PersistenceController.preview.container.viewContext),
                 appointmentStore: AppointmentStore(context: PersistenceController.preview.container.viewContext))
    }
}
