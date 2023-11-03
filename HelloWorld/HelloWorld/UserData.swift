//
//  UserData.swift
//  HelloWorld
//
//  Created by Tianze Xu on 23/9/2022.
//

import Foundation
var encoder = JSONEncoder()
var decoder = JSONDecoder()

class Note: ObservableObject {
    @Published var NoteList: [SingleNote]
    var count = 0
    
    init() {
        self.NoteList = []
    }
    init(data: [SingleNote]) {
        self.NoteList = []
        for item in data {
            self.NoteList.append(SingleNote(departure: item.departure, destination: item.destination, date: item.date, airplane: item.airplane, price: item.price, startingTime: item.startingTime, endTime: item.endTime, address: item.address, diary: item.diary, isStared: item.isStared, id: self.count))
            count += 1
        }
    }
    
    func add(data: SingleNote) {
        self.NoteList.append(SingleNote(departure: data.departure, destination: data.destination, date: data.date, airplane: data.airplane, price: data.price, startingTime: data.startingTime, endTime: data.endTime, address: data.address, diary: data.diary, isStared: data.isStared, id: self.count))
        self.count += 1
        
        self.dataStore()
    }
    
    func edit(data: SingleNote, id: Int) {
        self.NoteList[id].departure = data.departure
        self.NoteList[id].destination = data.destination
        self.NoteList[id].date = data.date
        self.NoteList[id].airplane = data.airplane
        self.NoteList[id].price = data.price
        self.NoteList[id].startingTime = data.startingTime
        self.NoteList[id].endTime = data.endTime
        self.NoteList[id].address = data.address
        self.NoteList[id].diary = data.diary
        self.NoteList[id].isStared = data.isStared
        self.NoteList[id].deleted = data.deleted
        self.dataStore()
    }
    
    func delete(id: Int) {
        self.NoteList[id].deleted = true
        self.dataStore()
    }
    
    func dataStore() {
        let dataStored = try! encoder.encode(self.NoteList)
        UserDefaults.standard.set(dataStored, forKey: "noteList") //N n
    }
    
}


struct SingleNote: Identifiable, Codable,Hashable{
    var departure: String = ""
    var destination: String = ""
    var date: Date = Date()
    var airplane: String = ""
    var price: String = "$"
    var startingTime: Date = Date()
    var endTime: Date = Date()
    var address: String = ""
    var diary: String = ""
    
    var isStared: Bool = false
    var deleted = false
    
    var id: Int = 0
}
