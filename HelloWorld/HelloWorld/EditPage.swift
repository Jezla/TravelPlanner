//
//  EditPage.swift
//  HelloWorld
//
//  Created by zichen on 2022/8/29.
//

import SwiftUI

struct EditPage: View {
    

    @EnvironmentObject var UserData: Note
    
    @State var departure: String = ""
    @State var destination: String = ""
    @State var date: Date = Date()
    @State var airplane: String = ""
    @State var price: String = ""
    @State var startingTime: Date = Date()
    @State var endTime: Date = Date()
    @State var address: String = ""
    @State var diary: String = ""
    @State var isStared = false
    
    var id: Int? = nil
    @Environment(\.presentationMode) var presentation
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Form() {
                        Section(header: Text("Plan Details")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.black)) {
                                HStack {
                                    Text("Departure")
                                    TextField("Departure", text: self.$departure).multilineTextAlignment(.trailing)
                                        .focused($isFocused)
                                        
                                }
                                HStack {
                                    Text("Destination")
                                    TextField("Destination", text: self.$destination).multilineTextAlignment(.trailing)
                                        .focused($isFocused)
                                        
                                }
                                DatePicker("Travel Date", selection: self.$date, displayedComponents: .date)
                                HStack {
                                    Text("Airplane To")
                                    TextField("Airplane to", text: self.$airplane).multilineTextAlignment(.trailing)
                                        .focused($isFocused)
                                        
                                }
                                HStack {
                                    Text("Price")
                                    
//                                    TextField("", text: Binding(
//                                                            get: { price },
//                                                            set: { newVal in
//                                                            if price.starts(with: "$") {
//                                                                price = newVal
//                                                            } else {
//                                                                price = "$" + newVal
//                                                            }
//                                                        })).keyboardType(.decimalPad)
                                    
                                    TextField("$", text: self.$price).multilineTextAlignment(.trailing).keyboardType(.decimalPad)
                                        .focused($isFocused)
                                        
                                }
                                HStack {
                                    Text("Start Time")
                                    DatePicker("", selection: self.$startingTime, displayedComponents: .hourAndMinute)
                                }
                                HStack {
                                    Text("End Time")
                                    DatePicker("", selection: self.$endTime, displayedComponents: .hourAndMinute)
                                }
                                HStack {
                                    Text("Arrive Address")
                                    TextField("Address", text: self.$address).multilineTextAlignment(.trailing)
                                        .focused($isFocused)
                                        
                                }
                        }
                        Section(header: Text("Diary Notes")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.black)){
                                TextEditor(text: self.$diary)
                                    .frame(height: 80)
                                    .focused($isFocused)
                                    .toolbar{
                                        ToolbarItemGroup(placement: .keyboard){
                                            Spacer()
                                            Button("Done"){
                                                print("Done")
                                                isFocused = false
                                            }
                                        }
                                    }
                                    
                        }
                        Section{
                            Toggle(isOn: self.$isStared){
                                Text("Star")
                            }
                        }

                        
                    }
                    
                }
                .navigationBarTitle(Text(departure.isEmpty ? (destination.isEmpty ? "" : "\(departure) → \(destination)") : "\(departure) → \(destination)"), displayMode: .inline)
                
            }
            
            
            HStack{
                
                Spacer()
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }) {
                    Text("Return")
                        
                        //.foregroundColor(.black)
                }
                .frame(width: 100, height: 50)
                
                Spacer()
                
                Button(action: {
                    if self.id == nil{ // add
                        self.UserData.add(data: SingleNote(departure: self.departure, destination: self.destination, date: self.date, airplane: self.airplane, price: self.price, startingTime: self.startingTime, endTime: self.endTime, address: self.address, diary: self.diary, isStared: self.isStared))
                        self.presentation.wrappedValue.dismiss()
                    }
                    else{ // edit
                        self.UserData.edit(data: SingleNote(departure: self.departure, destination: self.destination, date: self.date, airplane: self.airplane, price: self.price, startingTime: self.startingTime, endTime: self.endTime, address: self.address, diary: self.diary, isStared: self.isStared), id: self.id!)
                        self.presentation.wrappedValue.dismiss()
                    }

                }) {
                    Text("Save")
                        //.foregroundColor(.black)
                }
                .frame(width: 100, height: 50)
                .disabled(self.departure.isEmpty || self.destination.isEmpty)
                Spacer()
            }
            
        

            HLine()
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.width)
                //.position(x:195, y:760)
                .fixedSize()
            
            
            Button(action: {
                self.presentation.wrappedValue.dismiss()
            }) {
                Image(systemName: "house.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(hue: 0.521, saturation: 1.0, brightness: 1.0, opacity: 0.989))
                    .frame(width: 65.0)
                    //.position(x: 195, y: 375)
            }
            .fixedSize()
        }
        .ignoresSafeArea(.keyboard ,edges: .bottom)
        
//        Swipe the page outside the keyboard can close the keyboard
//        .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
    }
}

struct EditPage_Previews: PreviewProvider {
    static var previews: some View {
        EditPage()
    }
}
