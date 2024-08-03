import SwiftUI

struct AppointmentListView: View {
    @ObservedObject var store: AppointmentStore
    @State private var editing = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Appointments")
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Button(action: {
                    editing.toggle()
                }) {
                    Text(editing ? "Done" : "Edit")
                        .padding()
                }
            }

            List {
                ForEach(store.appointments, id: \.self) { appointment in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(appointment.name ?? "Unknown Appointment")
                            Text("\(appointment.date ?? Date(), formatter: DateFormatter.short)")
                        }
                        Spacer()
                        if editing {
                            Button(action: {
                                store.deleteAppointment(appointment: appointment)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            
            NavigationLink(destination: AddAppointmentView(store: store)) {
                Text("Add Appointment")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarTitle("Appointments", displayMode: .inline)
    }
}

struct AppointmentListView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentListView(store: AppointmentStore(context: PersistenceController.preview.container.viewContext))
    }
}
