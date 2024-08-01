//
//  MedicationStore.swift
//  Medy
//
//  Created by Utku on 21/07/24.
//

import Foundation
import CoreData
import UserNotifications

class MedicationStore: ObservableObject {
    private var context: NSManagedObjectContext

    @Published var medications: [Medication] = []
    @Published var appointments: [Appointment] = []
    @Published var nutrition: [Nutrition] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchMedications(for: Date())
        fetchData(for: Date())
    }

    func fetchMedications(for date: Date) {
        let request: NSFetchRequest<Medication> = Medication.fetchRequest()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)

        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate! as NSDate)
        do {
            medications = try context.fetch(request)
        } catch {
            print("Failed to fetch medications: \(error.localizedDescription)")
        }
    }

    func fetchData(for date: Date) {
        fetchMedications(for: date)

        // Appointments
        let appointmentRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest()
        appointmentRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)
        do {
            appointments = try context.fetch(appointmentRequest)
        } catch {
            print("Failed to fetch appointments: \(error)")
        }

        // Nutrition
        let nutritionRequest: NSFetchRequest<Nutrition> = Nutrition.fetchRequest()
        nutritionRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)
        do {
            nutrition = try context.fetch(nutritionRequest)
        } catch {
            print("Failed to fetch nutrition data: \(error)")
        }
    }

    func updateData(for date: Date) {
        fetchData(for: date)
    }

    func addMedication(name: String, dosage: String, frequency: String, isTaken: Bool, date: Date) {
        let newMedication = Medication(context: context)
        newMedication.id = UUID()
        newMedication.name = name
        newMedication.dosage = dosage
        newMedication.frequency = frequency
        newMedication.isTaken = isTaken
        newMedication.date = date

        saveContext()
        fetchData(for: date)
        scheduleNotification(for: newMedication)
    }

    func toggleMedicationTaken(medication: Medication) {
        medication.isTaken.toggle()
        saveContext()
        fetchMedications(for: medication.date ?? Date())
    }

    func deleteMedication(medication: Medication) {
        context.delete(medication)
        saveContext()
        fetchMedications(for: medication.date ?? Date())
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func scheduleNotification(for medication: Medication) {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "It's time to take your medication: \(medication.name ?? "your medication")"
        content.sound = UNNotificationSound.default

        guard let date = medication.date else { return }

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
