//
//  ContentView.swift
//  HelloWorld
//
//  Created by wzl on 2022/8/18.
//
import SwiftUI

func initUserData() -> [SingleNote] {
    var output: [SingleNote] = []
    if let dataStored = UserDefaults.standard.object(forKey: "noteList") as? Data {     //N n
        let data = try! decoder.decode([SingleNote].self, from: dataStored)
        for item in data {
            if !item.deleted {
                output.append(SingleNote(departure: item.departure, destination: item.destination, date: item.date, airplane: item.airplane, price: item.price, startingTime: item.startingTime, endTime: item.endTime, address: item.address, diary: item.diary, isStared: item.isStared, id: output.count))
            }
        }
    }
    return output
}

struct ContentView: View {
    
    @State var indexSetToDelete: IndexSet
    @State var showEditingPage = false;
    @State var showAlert = false;
    @ObservedObject var UserData: Note = Note(data: initUserData())
    
    @State private var searchText = ""
    
    
    var searchResults: [SingleNote] {
            if searchText.isEmpty {
                return UserData.NoteList
            } else {
                return UserData.NoteList.filter ({ str in
                    str.departure.lowercased().contains(searchText.lowercased()) || str.destination.lowercased().contains(searchText.lowercased())
        
               })
            }
        }
    
    
    
    var body: some View {
        
        
        
        VStack{
            titleView.fixedSize()
            
            VStack{
                Color.black.frame(height: 3 / UIScreen.main.scale)
            }
            
//            NavigationView {
//                Text("Hello, World!")
//                    .navigationBarTitle("Navigation")
//            }
            
            
            //search
//            NavigationView {
//                        Text("Searching for \(searchText)")
//                    .searchable(text: $searchText, prompt: "Look for something")
//                    }
            NavigationView {
                List{
                    ForEach(searchResults, id:\.self){item in
                        if !item.deleted{
                            CardView(index: item.id).environmentObject(self.UserData)
                        }
                    }.onDelete{(indexSet) in
                        self.showAlert = true
                        self.indexSetToDelete = indexSet
                    }.alert(isPresented:$showAlert) {
                        Alert(
                            title: Text("Are you sure you want to delete this entry?"),
                            message: Text("This will delete this permanently"),
                            primaryButton: .destructive(
                                Text("Delete")) {
                                    for i in indexSetToDelete{
                                        //self.UserData.NoteList[i].deleted = true
                                        self.UserData.delete(id: i)
                                    }
                                },
                            secondaryButton: .cancel()
                                
                            )
                        
                }
                    //.listRowBackground(Color(hue: 0.521, saturation: 0.373, brightness: 0.966, opacity: 0.989))
                }.searchable(text: $searchText)
                .navigationTitle(Text("Searchable"))
            }
            
            
            
            

//            NavigationView{
//                VStack {
//                    List{
//                        ForEach(self.UserData.NoteList) {item in
//                            if !item.deleted{
//                                CardView(index: item.id).environmentObject(self.UserData)
//                            }
//                        }
//                        .onDelete(perform: removeCard)
//
//
//                    }
//                }
//
//            }
            
            
            Spacer()
            
            HLine()
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.width)
                //.position(x:195, y:170)
                .fixedSize()
            
            HStack{
                
                Spacer()
                    .frame(width: 60)
                
                Image(systemName: "house.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 65)
                    .foregroundColor(.gray)
                    //.position(x: 100, y: 50)
                    .fixedSize()
                
                Spacer()
                    .frame(width: 180)
                
                Button(action: {
                    self.showEditingPage = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 65.0)
                        .foregroundColor(Color(hue: 0.521, saturation: 1.0, brightness: 1.0, opacity: 0.989))
                        //.position(x: 1, y: 100)
                }
                .fixedSize()
                .sheet(isPresented: self.$showEditingPage, content: {EditPage().environmentObject(self.UserData)})
                
                Spacer()
                    .frame(width: 50)
                
            }
            
        }
        .ignoresSafeArea(.keyboard ,edges: .bottom)
    
    }
    
    
    
    struct CardView: View{
        
        @EnvironmentObject var UserData: Note
        var index: Int
        @State var showEditingPage = false
        var body: some View{
            Button(action: {
                self.showEditingPage = true})
            {
                Group{
                    ZStack{
                        RoundedRectangle(cornerRadius: 15, style: .continuous).fill(Color(hue: 0.521, saturation: 0.373, brightness: 0.966, opacity: 0.989))

                        Text(self.UserData.NoteList[index].departure + " → " + self.UserData.NoteList[index].destination)
                        .font(.system(size: 20))
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height / 18, alignment: .center)

                        if self.UserData.NoteList[index].isStared{
                            Image(systemName: "star.fill")
                                .imageScale(.large)
                                .foregroundColor(.yellow)
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height / 18, alignment: .trailing)
                        }
                    }
                }
            }.sheet(isPresented: self.$showEditingPage,content: {EditPage(
                departure: self.UserData.NoteList[index].departure,
                destination: self.UserData.NoteList[index].destination,
                date: self.UserData.NoteList[index].date,
                airplane: self.UserData.NoteList[index].airplane,
                price: self.UserData.NoteList[index].price,
                startingTime: self.UserData.NoteList[index].startingTime,
                endTime: self.UserData.NoteList[index].endTime,
                address: self.UserData.NoteList[index].address,
                diary: self.UserData.NoteList[index].diary,
                isStared: self.UserData.NoteList[index].isStared,
                id: index).environmentObject(self.UserData)})
            
            
        }
        
    }
    
    
    var titleView: some View {
        Image("image2")
            .resizable()
            .frame(width: 325, height: 63)
    }
}

//horizontal line
struct HLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
            path.move(to: CGPoint(x: rect.minX, y: (rect.minY-7)))
            path.addLine(to: CGPoint(x: rect.maxX, y: (rect.minY-7)))
            return path
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(indexSetToDelete: IndexSet())
        }
    }
}

