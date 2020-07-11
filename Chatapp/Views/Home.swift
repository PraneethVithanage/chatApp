//
//  Home.swift
//  Chatapp
//
//  Created by praneeth vithanage on 7/10/20.
//  Copyright © 2020 praneeth vithanage. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
struct Home : View {
    @State var myuid = UserDefaults.standard.value(forKey: "UserName")as! String
    @EnvironmentObject var datas : MainObservable
    @State var show = false
    @State var chat = false
    @State var uid = ""
    @State var name = ""
    @State var pic = ""
    
    var body : some View {
        
        ZStack{
            NavigationLink(destination:ChatView(name: self.name, pic: self.pic, uid: self.uid, chat: self.$chat),isActive: self.$chat){
                   Text("")
                  VStack{
                    
                    if self.datas.recents.count == 0{
                         Indicator()
                    }else{
                       
                        
                        ScrollView(.vertical,showsIndicators: false){
                            VStack(spacing:12){
                          ForEach(datas.recents){i in
                            Button(action:{
                                self.uid = i.id
                                self.name = i.name
                                self.pic = i.pic
                                self.chat.toggle()
                                }){
                                      RecentCellView(url: i.pic, name: i.name, time: i.time, date: i.date, lastmsg: i.lastmsg)
                                 }
                                }
                            }.padding()
                             
                           }
                
                       }
                  
                   }.navigationBarTitle("Home",displayMode: .inline)
                    .navigationBarItems(leading:
                       
                       Button(action: {
                           
                       }, label:{
                           Text("Sing Out")
                        })
                       
                       , trailing:
                       
                        Button(action: {
                            self.show.toggle()
                           }, label:{
                                       Image(systemName: "square.and.pencil").resizable().frame(width: 25,height: 25)
                           })
                   
                )
            }
        }
        
        .sheet(isPresented: self.$show){
            newChatView(name: self.$name, uid: self.$uid, pic: self.$pic, show: self.$show, chat: self.$chat)
            }
           }
      }

struct RecentCellView : View {
    var url : String
    var name : String
    var time : String
    var date : String
    var lastmsg : String
    
    var body : some View {
        HStack{
            AnimatedImage(url:URL(string: url)!).resizable().renderingMode(.original).frame(width: 55,height: 55).clipShape(Circle())
            VStack{
                HStack{
                    VStack(alignment:.leading,spacing: 6){
                        Text(name)
                        Text(lastmsg).foregroundColor(.gray)
                        
                    }
                    Spacer()
                    VStack(alignment:.leading,spacing: 6){
                         Text(date).foregroundColor(.gray)
                         Text(time).foregroundColor(.gray)
                    
                    }
                }
                Divider()
            }
        }
    }
}

struct newChatView:View {
    @ObservedObject var datas = getAllUsers()
    @Binding var name : String
    @Binding var uid : String
    @Binding var pic : String
    @Binding var show : Bool
    @Binding var chat : Bool
    var body : some View{
        
        VStack(alignment:.leading){
            
            Text("Select To Chat").foregroundColor(Color.black.opacity(0.5)).padding()
            
          VStack{
                       
                       if self.datas.users.count == 0{
                            Indicator()
                       }else{
                          
                           
                           ScrollView(.vertical,showsIndicators: false){
                               VStack(spacing:12){
                             ForEach(datas.users){i in
                                Button(action:{
                                    
                                    self.uid = i.id
                                    self.name = i.name
                                    self.pic = i.pic
                                    self.show.toggle()
                                    self.chat.toggle()
                                }){
                                
                                
                                UserCellView(url: i.pic, name: i.name, about: i.about)
                                       
                                     }
                                 }
                                
                            }
                        }
                   }
                 }.padding(.horizontal)
              }
         }

}
class getAllUsers : ObservableObject{
    @Published var users = [User]()
    
    init(){
        
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments {(snap,err)in
            if err != nil{
                print((err?.localizedDescription))
               return
           }
            for i in snap!.documents{
                
                let id = i.documentID
                let name = i.get("name")as! String
                let pic = i.get("pic")as! String
                let about = i.get("about")as! String
                
                self.users.append(User(id:id, name:name, pic:pic, about:about))
                
                
            }
        }
    }
}
struct User:Identifiable{
    var id : String
    var name: String
    var pic : String
    var about : String
    
}
struct UserCellView : View {
    var url : String
    var name : String
    var about : String
    
    
    var body : some View {
        HStack{
            AnimatedImage(url:URL(string: url)!).resizable().renderingMode(.original).frame(width: 55,height: 55).clipShape(Circle())
            VStack{
                HStack{
                    VStack(alignment:.leading,spacing: 6){
                        Text(name)
                        Text(about).foregroundColor(.gray)
                        
                    }
                    Spacer()
                   
                    
                    }
                }
                Divider()
            }
        }
    }

struct ChatView:View {
    var name : String
    var pic : String
    var uid : String
    @Binding var chat : Bool
    
    var body : some View{
        VStack{
            Text("Hello")
                .navigationBarTitle("\(name)",displayMode: .inline)
                .navigationBarItems(leading:Button(action:{
                    self.chat.toggle()
                  }, label:{
                                Image(systemName: "arrow.left").resizable().frame(width: 25,height: 25)
             }))
            
        }
    }
  }

