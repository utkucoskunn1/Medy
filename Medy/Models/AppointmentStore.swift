//
//  AppointmentStore.swift
//  Medy
//
//  Created by Utku on 03/08/24.
//

import Foundation
import CoreData

class AppointmentStore: ObservableObject {
    @Published var appointments: [Appointment] = []

    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchAppointments()
    }

    func fetchAppointments() {
        let request: NSFetchRequest<Appointment> = Appointment.fetchRequest()
        do {
            appointments = try context.fetch(request)
        } catch {
            print("Error fetching appointments: \(error)")
        }
    }

    func addAppointment(name: String, date: Date) {
        let newAppointment = Appointment(context: context)
        newAppointment.name = name
        newAppointment.date = date

        saveContext()
        fetchAppointments()
    }

    func deleteAppointment(appointment: Appointment) {
        context.delete(appointment)
        saveContext()
        fetchAppointments()
    }

    func updateData(for date: Date) {
        fetchAppointments()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
