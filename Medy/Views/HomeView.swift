//
//  HomeView.swift
//  Medy
//
//  Created by Utku on 21/07/24.
//


import SwiftUI

struct HomeView: View {
    @ObservedObject var store: MedicationStore
    @State private var patientName: String = "John Doe"
    @State private var selectedDate: Date = Date()

    var body: some View {
        VStack {
            // Üst kısım: Tarih ve Hasta İsmi
            HStack {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding()
                    .onChange(of: selectedDate) {
                        store.updateData(for: selectedDate)
                    }
                Spacer()
                Text(patientName)
                    .font(.headline)
                    .padding()
            }

            // Ortadaki 4 bölüm
            VStack(spacing: 10) {
                // Medications bölümü
                SectionView(title: "Medications", icon: "pills") {
                    List {
                        ForEach(store.medications, id: \.self) { medication in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(medication.name ?? "Unknown Medication")
                                        .font(.headline)
                                    Text("Dosage: \(medication.dosage ?? "Unknown Dosage")")
                                    Text("Frequency: \(medication.frequency ?? "Unknown Frequency")")
                                }
                                Spacer()
                                Button(action: {
                                    store.toggleMedicationTaken(medication: medication)
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
                }
                // Appointments bölümü
                SectionView(title: "Appointments", icon: "calendar") {
                    if store.appointments.isEmpty {
                        Text("No appointments today")
                    } else {
                        List(store.appointments, id: \.self) { appointment in
                            Text(appointment.name ?? "Unknown Appointment")
                        }
                    }
                }

                // Nutrition bölümü
                SectionView(title: "Nutrition", icon: "leaf") {
                    if store.nutrition.isEmpty {
                        Text("No nutrition data today")
                    } else {
                        List(store.nutrition, id: \.self) { nutrition in
                            Text(nutrition.name ?? "Unknown Nutrition")
                        }
                    }
                }
            }
            .padding()

            Spacer()
        }
        .onAppear {
            store.updateData(for: selectedDate)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: MedicationStore(context: PersistenceController.preview.container.viewContext))
    }
}
