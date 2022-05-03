import Foundation
import Firebase
import SwiftUI
import Combine

class AppointmentVM: ObservableObject {
    @Published var appointments = [Appointment]()
    @Published var organAppointments = [OrganAppointment]()
    @Published var bloodAppointments = [BloodAppointment]()
    @Published var filteredAppointments: [BloodAppointment] = [BloodAppointment]()
    @Published var added = true
    @Published var appointmentsWithin = [DAppointment]()
    @Published var appointmentsWithin2 = [String: [DAppointment]]()
    var BloodApppointmentsCancellable: AnyCancellable?

    
    init() {
        self.fetchOrganAppointments()
        self.fetchOrganAppointments()
    }
    
    let db = Firestore.firestore()
    
    func fetchData() {
        db.collection("appointments").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointments = documents.map { (queryDocumentSnapshot) -> Appointment in
                
                let data = queryDocumentSnapshot.data()
                let type = data["type"] as? String ?? ""
                let appointments: [DAppointment] = self.fetchAppointmentsData(doc: queryDocumentSnapshot)
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                let stamp3 = data["date"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                let hospital = data["hospital"] as? String ?? ""
                
                let bookedApts = data["bookedAppointments"] as? [String] ?? [String]()
                
                if (type == "blood"){
                    let aptDuration = 30.0
                    let donors = data["donors"] as? Int ?? 0
                    
                    var apt = BloodAppointment(type: type, startTime: startTime, endTime: endTime,
                                               aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, donors: donors)
                    
                    apt.bookedAppointments = bookedApts
                    apt.appointments = appointments
                    
                    return apt
                }
                else {
                    let organ = data["organ"] as? String ?? ""
                    let aptDuration = 60.0
                    var apt = OrganAppointment(type: type, startTime: startTime, endTime: endTime,
                                               aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, organ: organ)
                    apt.appointments = [DAppointment]()
                    apt.bookedAppointments = bookedApts
                    return apt
                }
            }
        }
        
        //        db.collection("appointments").whereField("type", in: ["organ"]).addSnapshotListener { (querySnapshot, error) in
        //            guard let documents = querySnapshot?.documents else {
        //                print("no documents")
        //                return
        //            }
        //
        //            self.appointments = documents.map { (queryDocumentSnapshot) -> OrganAppointment in
        //                let data = queryDocumentSnapshot.data()
        //                let type = data["type"] as? String ?? ""
        //                let appointments: [DAppointment] = self.fetchAppointmentsData(doc: queryDocumentSnapshot)
        //
        //                let stamp1 = data["start_time"] as? Timestamp
        //                let startTime = stamp1!.dateValue()
        //
        //                let stamp2 = data["end_time"] as? Timestamp
        //                let endTime = stamp2!.dateValue()
        //
        //                let stamp3 = data["date"] as? Timestamp
        //                let aptDate = stamp3?.dateValue()
        //
        //                let hospital = data["hospital"] as? String ?? ""
        //                let aptDuration = 60.0
        //                let organ = data["organ"] as? String ?? ""
        //
        //                return OrganAppointment(appointments: appointments, type: type, startTime: startTime, endTime: endTime,
        //                                   aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, organ: organ)
        //            }
        //        }
        
        
    }
    
    func fetchAppointmentsData(doc: QueryDocumentSnapshot) -> [DAppointment] {
        let docID = doc.documentID
        
        db.collection("appointments").document(docID).collection("appointments").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointmentsWithin = documents.map { (queryDocumentSnapshot) -> DAppointment in
                let data = queryDocumentSnapshot.data()
                let type = data["type"] as? String ?? ""
                let donor = data["donor"] as? String ?? ""
                let hName = data["hospital"] as? String ?? ""
                let confirmed = data["confirmed"] as? String ?? ""
                let booked = data["booked"] as? Bool ?? false
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                return DAppointment(type: type, startTime: startTime, endTime: endTime, donor: donor, hName: hName, confirmed: confirmed, booked: booked)
            }
        }
        
        
        return self.appointmentsWithin
    }
    
    func fetchAppointmentsData2(docID: String) -> [String: [DAppointment]] {
        var appointment = [DAppointment]()
        var appointments = [DAppointment]()
        var appointmentID = ""
        
        db.collection("appointments").document(docID).collection("appointments").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            appointment = documents.map { (queryDocumentSnapshot) -> DAppointment in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let appointmentID = queryDocumentSnapshot.documentID
                let type = data["type"] as? String ?? ""
                let donor = data["donor"] as? String ?? ""
                let hName = data["hospital"] as? String ?? ""
                let confirmed = data["confirmed"] as? String ?? ""
                let booked = data["booked"] as? Bool ?? false
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                var apt = DAppointment(type: type, startTime: startTime, endTime: endTime, donor: donor, hName: hName, confirmed: confirmed, booked: booked)
                apt.docID = id
                appointments.append(apt)
                return apt
            }
            
            self.appointmentsWithin2.updateValue(appointments, forKey: docID)
        }
        
        return self.appointmentsWithin2
    }
    
//    func fetchBloodAppointmentsData(docID: String) -> [DAppointment] {
//        var appointment = [DAppointment]()
//        var appointments = [DAppointment]()
//
//        self.db.collection("appointments").document(docID).collection("appointments").addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("no documents")
//                return
//            }
//
//            self.BloodApppointmentsCancellable = Future<[DAppointment], Error> { promise in
//                DispatchQueue.main.async {
//                    appointments = documents.map { (queryDocumentSnapshot) -> DAppointment in
//                        let data = queryDocumentSnapshot.data()
//                        let id = queryDocumentSnapshot.documentID
//                        let type = data["type"] as? String ?? ""
//                        let donor = data["donor"] as? String ?? ""
//                        let hName = data["hospital"] as? String ?? ""
//                        let confirmed = data["confirmed"] as? String ?? ""
//                        let booked = data["booked"] as? Bool ?? false
//
//                        let stamp1 = data["start_time"] as? Timestamp
//                        let startTime = stamp1!.dateValue()
//
//                        let stamp2 = data["end_time"] as? Timestamp
//                        let endTime = stamp2!.dateValue()
//
//                        var apt = DAppointment(type: type, startTime: startTime, endTime: endTime, donor: donor, hName: hName, confirmed: confirmed, booked: booked)
//                        apt.docID = id
//                        return apt
//                    }
//                    if(!appointments.isEmpty) {
//                        promise(.success(appointments))
//                    }
//                }
//
//            }.receive(on: DispatchQueue.main
//                ).sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        print("finished")
//                    case .failure(let error):
//                        print(error)
//                    }
//                }, receiveValue: { appointments in
//                    print(appointments)
//                    if(success){
//                        addToUser()
//                    } else {
//                        self.removeFromInnerAppointment(appointmentID: self.exact.docID, mainAppointmentId: self.appointment.docID)
//                        let x =
//                        config.hostingController?.parent as! Alive4thVC
//                        x.fail()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//                            listener?.remove()
//                        }
//                        print("failed")
//                    }
//                })
//
//        }
//
//    }
    
    func fetchBloodAppointmentsData(docID: String) -> Future<[DAppointment], Error> {
        var appointments = [DAppointment]()
        
        
        return Future<[DAppointment], Error> { promise in
            
            DispatchQueue.main.async {
                
                self.db.collection("appointments").document(docID).collection("appointments").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("no documents")
                        return
                    }
                    
                    appointments = documents.map { (queryDocumentSnapshot) -> DAppointment in
                        let data = queryDocumentSnapshot.data()
                        let id = queryDocumentSnapshot.documentID
                        let type = data["type"] as? String ?? ""
                        let donor = data["donor"] as? String ?? ""
                        let hName = data["hospital"] as? String ?? ""
                        let confirmed = data["confirmed"] as? String ?? ""
                        let booked = data["booked"] as? Bool ?? false
                        
                        let stamp1 = data["start_time"] as? Timestamp
                        let startTime = stamp1!.dateValue()
                        
                        let stamp2 = data["end_time"] as? Timestamp
                        let endTime = stamp2!.dateValue()
                        
                        var apt = DAppointment(type: type, startTime: startTime, endTime: endTime, donor: donor, hName: hName, confirmed: confirmed, booked: booked)
                        apt.docID = id
                        return apt
                    }
                    
                    if(!appointments.isEmpty) {
                        promise(.success(appointments))
                    }
                }
                
            }
            
            
        }
    }


    
    
    func addData(apt: BloodAppointment) {
        // Add doc to collection
        let newDoc = db.collection("appointments").document()
        newDoc.setData(["type": apt.type,"hospital": apt.hospital, "start_time": apt.startTime,
                        "end_time": apt.endTime, "date": apt.aptDate, "appointment_duration": 30
                        , "donors": apt.donors, "bookedAppointments": apt.bookedAppointments ]) { error in
            
            if (error == nil){
                
            } else {
                print(error!)
                self.added = false
            }
        }
        
        // add collection to doc
        
        for index in 0...(apt.appointments!.count - 1) {
            let miniApt = apt.appointments![index]
            newDoc.collection("appointments").addDocument(data: ["type": miniApt.type , "start_time": miniApt.startTime,
                                                                 "end_time": miniApt.endTime,  "donor": miniApt.donor
                                                                 , "confirmed": miniApt.confirmed, "booked": miniApt.booked,
                                                                 "hospital": miniApt.hName]) { error in
                if (error == nil){
                    
                } else {
                    print(error!)
                    self.added = false
                }
            }
        }
        
    } // end of addData
    
    func addDataOrgan(apt: OrganAppointment) {
        // Add doc to collection
        let newDoc = db.collection("appointments").document()
        newDoc.setData(["type": apt.type,"hospital": apt.hospital, "start_time": apt.startTime,
                        "end_time": apt.endTime, "date": apt.aptDate, "appointment_duration": 60
                        , "organ": apt.organ , "bookedAppointments": apt.bookedAppointments ]) { error in
            
            if (error == nil){
                
            } else {
                print(error!)
                self.added = false
            }
        }
        
        // add collection to doc
        
        for index in 0...(apt.appointments!.count - 1) {
            let miniApt = apt.appointments![index]
            newDoc.collection("appointments").addDocument(data: ["type": miniApt.type , "start_time": miniApt.startTime,
                                                                 "end_time": miniApt.endTime,  "donor": miniApt.donor
                                                                 , "confirmed": miniApt.confirmed, "booked": miniApt.booked,
                                                                 "hospital": miniApt.hName]) { error in
                if (error == nil){
                    
                } else {
                    print(error!)
                    self.added = false
                }
            }
        }
        
    } // end of addData
    
    
    func fetchOrganAppointments() {
        
        self.organAppointments.removeAll()
        
        db.collection("appointments").whereField("type", in: ["organ"]).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointments = documents.map { (queryDocumentSnapshot) -> OrganAppointment in
                print("documents")
                let data = queryDocumentSnapshot.data()
                let type = data["type"] as? String ?? ""
//                let docID = queryDocumentSnapshot.documentID
                
                let appointments: [DAppointment] = self.fetchAppointmentsData(doc: queryDocumentSnapshot)
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                let stamp3 = data["date"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                let hospital = data["hospital"] as? String ?? ""
                let organ = data["organ"] as? String ?? ""
                let bookedApts = data["bookedAppointments"] as? [String] ?? [String]()
                print("\(organ)")
                let aptDuration = 60.0
                
                let apt = OrganAppointment(type: type, startTime: startTime, endTime: endTime,
                                           aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, organ: organ)
                apt.docID = queryDocumentSnapshot.documentID
                apt.bookedAppointments = bookedApts
                apt.appointments?.append(appointments[0])
                
                //                if(!apt.appointments!.isEmpty){
                //                    print("document3333")
                //
                //                }
                
                if((hospital == Constants.selected.selectedOrgan.hospital) && (organ == Constants.selected.selectedOrgan.organ)){
                    self.organAppointments.append(apt)
                }
                return apt
                
            }
            
        }
            
    }
    
    func fetchBloodAppointments() {
        
        self.bloodAppointments.removeAll()
        
        db.collection("appointments").whereField("type", in: ["blood"]).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointments = documents.map { (queryDocumentSnapshot) -> BloodAppointment in
                print("documents")
                let data = queryDocumentSnapshot.data()
                let type = data["type"] as? String ?? ""
                
                let appointments: [DAppointment] = self.fetchAppointmentsData(doc: queryDocumentSnapshot)
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                let stamp3 = data["date"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                let hospital = data["hospital"] as? String ?? ""
                let bookedApts = data["bookedAppointments"] as? [String] ?? [String]()
                let aptDuration = 60.0
                
                let apt = BloodAppointment(type: type, startTime: startTime, endTime: endTime,
                                           aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, donors: 3)
                apt.docID = queryDocumentSnapshot.documentID
                apt.bookedAppointments = bookedApts
                
                if((hospital == Constants.selected.selectedOrgan.hospital)){
                    self.bloodAppointments.append(apt)
                }
                return apt
                
            }
            
        }
            
    }

    
    
    @Published var currentDay: Date = Date()
    
    
    func filteringAppointments() -> [BloodAppointment] {
        let calender = Calendar.current
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            if(!self.bloodAppointments.isEmpty){
                
                var filtered: [BloodAppointment] = self.bloodAppointments.filter {
                    return calender.isDate($0.aptDate, inSameDayAs: self.currentDay)
                }
                
//                if(self.organAppointments.first?.appointments != nil){
//                    filtered = filtered.filter {
//                        return !(($0.appointments?.first?.booked)!)
//                    }}
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.filteredAppointments = filtered
                    }
                }
            }
            
        }
        return self.filteredAppointments
    }
    
    
}
